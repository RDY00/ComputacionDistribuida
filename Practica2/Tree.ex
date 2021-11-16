defmodule Tree do

  def new(n) do
    create_tree(Enum.map(1..n, fn _ -> spawn(fn -> loop() end) end), %{}, 0)
  end

  defp loop() do
    receive do
      {:broadcast, tree, i, caller} ->
        l = Map.get(tree, 2*i+1)
        r = Map.get(tree, 2*i+2)

        case {l,r} do
          {nil, nil} -> send(caller, {self(), :ok})
          {l,r} -> 
            send(l, {:broadcast, tree, 2*i+1, caller})
            if r, do: send(r, {:broadcast, tree, 2*i+2, caller})
        end

        loop()

      {:convergecast, tree, i, caller} ->
        # Si tenemos dos hijos, atrapamos el mensaje del otro aqui
        if Map.get(tree, 2*i + 2) do
          receive do
            {:convergecast, _, _, _} -> :ok
          end
        end

        case i do
          0 -> send(caller, {self(), :ok})
          _ ->
            p = div(i-1, 2)
            Map.get(tree, p) |> send({:convergecast, tree, p, caller})
        end

        loop()

      {:broadconvergecast, tree, i, caller} ->
        l = 2*i+1
        r = 2*i+2
        p = div(i-1, 2)
        # Mini fabrica de mensajes UwU 
        msg = &({:broadconvergecast, tree, &1, caller})

        case {Map.get(tree, l), Map.get(tree, r)} do
          {nil, nil} -> 
            send(caller, {self(), :ok})
          {ln, nil} ->
            send(ln, msg.(l))
            receive do {:broadconvergecast, _, _, _} -> :ok end
          {ln, rn} ->
            send(ln, msg.(l))
            send(rn, msg.(r))
            receive do {:broadconvergecast, _, _, _} -> :ok end
            receive do {:broadconvergecast, _, _, _} -> :ok end
        end

        case i do
          0 -> send(caller, {self(), :ok})
          _ -> Map.get(tree, p) |> send(msg.(p))
        end

        loop()

      {:convergebroadcast, tree, i, caller} ->
        if Map.get(tree, 2*i + 2) do
          receive do
            {:convergebroadcast, _, _, _} -> :ok
          end
        end

        case i do
          0 -> send(caller, {self(), :ok})
          _ ->
            p = div(i-1, 2)
            Map.get(tree, p) |> send({:convergebroadcast, tree, p, caller})
            receive do {:convergebroadcast, _, _, _} -> :ok end
        end

        l = Map.get(tree, 2*i+1)
        r = Map.get(tree, 2*i+2)

        case {l,r} do
          {nil, nil} -> send(caller, {self(), :ok})
          {l,r} -> 
            send(l, {:convergebroadcast, tree, 2*i+1, caller})
            if r, do: send(r, {:convergebroadcast, tree, 2*i+2, caller})
        end

        loop()
    end
  end

  defp create_tree([], tree, _) do
    tree
  end

  defp create_tree([pid | l], tree, pos) do
    create_tree(l, Map.put(tree, pos, pid), (pos+1))
  end

  def broadcast(tree, n) do
    Map.get(tree, 0) |> send({:broadcast, tree, 0, self()})
    Enum.map(1..div(n+1, 2), fn _ -> receive do x -> x end end)
  end

  def convergecast(tree, n) do
    first_leaf = n - div(n+1, 2)
    Enum.each(first_leaf..n-1, fn x -> Map.get(tree, x) |> send({:convergecast, tree, x, self()}) end)
    receive do x -> x end
  end

  def broadconvergecast(tree, n) do
    Map.get(tree, 0) |> send({:broadconvergecast, tree, 0, self()})
    Enum.map(0..div(n+1, 2), fn _ -> receive do x -> x end end)
  end

  def convergebroadcast(tree, n) do
    first_leaf = n - div(n+1, 2)
    Enum.each(first_leaf..n-1, fn x -> Map.get(tree, x) |> send({:convergebroadcast, tree, x, self()}) end)
    Enum.map(0..div(n+1, 2), fn _ -> receive do x -> x end end)
  end

end
