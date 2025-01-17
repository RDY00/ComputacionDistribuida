defmodule Graph do
  
  def new(n) do
    create_graph(Enum.map(1..n, fn _ -> spawn(fn -> loop(-1) end) end), %{}, n)
  end

  defp loop(state) do
    receive do
      {:bfs, graph, new_state} ->
        cond do 
          state == -1 || new_state < state ->
            Enum.each(Map.get(graph, self()), fn v -> send(v, {:bfs, graph, new_state+1}) end)
            loop(new_state)
          true ->
            loop(state)
        end

      {:dfs, graph, new_state, parents} ->
        # Mi padre
        my_p = Map.get(parents, self())
        # Vertices no visitados
        nv = Map.get(graph, self())
             |> Enum.filter(fn x -> !Map.has_key?(parents, x) end)

        case nv do
          [] ->
            if my_p != self(), do: send(my_p, {:dfs, graph, new_state-1, parents})
          [x|_] ->
            # nv = Enum.into(nv, MapSet.new())
            # graph = Map.put(graph, self(), nv)
            parents = Map.put(parents, x, self())
            send(x, {:dfs, graph, new_state+1, parents})
        end

        if state == -1, do: loop(new_state), else: loop(state)

      {:get_state, caller} -> send(caller, {self(), state}) #Estos mensajes solo los manda el main.
    end
  end
  
  defp create_graph([], graph, _) do
    graph
  end

  defp create_graph([pid | l], graph, n) do
    g = create_graph(l, Map.put(graph, pid, MapSet.new()), n)
    e = :rand.uniform(div(n*(n-1), 2))
    create_edges(g, e)
  end

  defp create_edges(graph, 0) do
    graph
  end

  defp create_edges(graph, n) do
    nodes = Map.keys(graph)
    create_edges(add_edge(graph, Enum.random(nodes), Enum.random(nodes)), n-1)
  end

  defp add_edge(graph, u, v) do
    cond do
      u == nil or v == nil -> graph
      u == v -> graph
      true ->
        u_neighs = Map.get(graph, u)
        new_u_neighs = MapSet.put(u_neighs, v)
        graph = Map.put(graph, u, new_u_neighs)
        v_neighs = Map.get(graph, v)
        new_v_neighs = MapSet.put(v_neighs, u)
        Map.put(graph, v, new_v_neighs)
    end
  end

  def random_src(graph) do
    Enum.random(Map.keys(graph))
  end
  
  def bfs(graph, src) do
    send(src, {:bfs, graph, 0})
    Process.sleep(5000)
    Enum.each(Map.keys(graph), fn v -> send(v, {:get_state, self()}) end)
    n = length(Map.keys(graph))
    Enum.map(1..n, fn _ -> receive do y -> y end end)
  end

  def bfs(graph) do
    bfs(graph, random_src(graph))
  end
    
  def dfs(graph, src) do
    send(src, {:dfs, graph, 0, %{src => src}})
    Process.sleep(5000)
    Enum.each(Map.keys(graph), fn v -> send(v, {:get_state, self()}) end)
    n = length(Map.keys(graph))
    Enum.map(1..n, fn _ -> receive do y -> y end end)
  end

  def dfs(graph) do
    dfs(graph, random_src(graph))
  end
  
end
