defmodule GeneratePackage do

  def new(n) do
    Enum.map(1..n, fn x -> num = :rand.uniform(2)-1 end)
  end
  
end

defmodule SlidingWindow do

  def new(n) do
    package = GeneratePackage.new(n)
    k = :rand.uniform(div(n, 2))
    sender = spawn(fn -> sender_loop(package, n, k) end)
    recvr = spawn(fn -> recvr_loop(sender) end)
    # Usamos esto para poder usar esta funcion en las pruebas
    {sender, recvr}
  end

  def sender_loop(package, n, k) do
    receive do
      {:start, recvr} ->
        map_package(%{}, package, 0) |> send_package(recvr, n, k, 0)
        sender_loop(package, n, k)

      {:end, pid} -> send(pid, package)
      
      _ -> sender_loop(package, n, k)
    end
  end

  # Se guardan como %{indice => {elemento, enviado, recibido}}
  defp map_package(map, package, i) do
    case package do
      [] -> map
      [h|l] -> map_package(Map.put(map, i, {h,false,false}), l, i+1)
    end
  end

  defp send_package(package, recvr, n, k, pos) do
    # Encuentra el siguiente mensaje no que ha sido confirmado
    if pos == n do
      send(recvr, :end_of_package)
      receive do 
        :ack_eop -> :ok
        _ -> :error  
      end 
    else
      {_,_,ack} = Map.get(package, pos)
      if ack do
        send_package(package, recvr, n, k, pos+1)
      else
        # Envia todos los de la ventana que no han sido enviados
        package_mod = send_window_items(package, recvr, n, k, pos, 0)

        receive do
          {:ack_elem, i} ->
            {elem,_,_} = Map.get(package_mod, i)
            send_package(Map.put(package_mod,i,{elem, true, true}), recvr, n, k, pos)

          _ -> :error
        end
      end
    end
  end

  defp send_window_items(package, recvr, n, k, pos, i) do
    if i == k or pos+i == n do
      package
    else
      {e, snd, ack} = Map.get(package, pos+i)
      if not snd do
        send(recvr, {:pkg_elem, e, pos+i})
        send_window_items(Map.put(package, pos+i, {e,true,ack}), recvr, n, k, pos, i+1)
      else
        send_window_items(package, recvr, n, k, pos, i+1)
      end
    end
  end

  def recvr_loop(sender) do
    send(sender, {:start, self()})
    package_map = get_package(sender, %{})
    n = length(Map.keys(package_map))
    package = Enum.map(0..n-1, fn i -> Map.get(package_map, i) end)

    receive do
      {:end, pid} -> send(pid, package)
      _ -> :error
    end
  end

  defp get_package(sender, package) do
    receive do
      {:pkg_elem, e, i} ->
        send(sender, {:ack_elem, i})
        get_package(sender, Map.put(package, i, e))
      :end_of_package -> 
        send(sender, :ack_eop)
        package
      _ -> get_package(sender, package)
    end
  end

end
