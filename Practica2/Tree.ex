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
          {nil, nil} -> send(caller, {self(), :ok_bc})
          {l,r} -> 
            if l, do: send(l, {:broadcast, tree, 2*i+1, caller})
            if r, do: send(r, {:broadcast, tree, 2*i+2, caller})
        end

      {:convergecast, tree, i, caller} -> :ok #Aquí va su código.
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
  end

  def convergecast(tree, n) do
    #Aquí va su código.
    :ok
  end
  
end
