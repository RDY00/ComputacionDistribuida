defmodule Consensus do

  def create_consensus(n) do
    #Crear n hilos pero cada uno de esos hilos va
    #a escoger un número completamente al azar.
    #El deber del estudiante es completar la función loop
    #para que al final de un número de ejecuciones de esta,
    #todos los hilos tengan el mismo número, el cual va a ser enviado vía un
    #mensaje al hilo principal.
    Enum.map(1..n, fn _ ->
      spawn(fn -> loop(:start, 0, :rand.uniform(10)) end)
    end)
    #Agregar código es válido.
  end
  
  defp loop(state, value, miss_prob) do
    #inicia código inamovible.
    if(state == :fail) do
      loop(state, value, miss_prob)
    end
    # Termina código inamovible.
    receive do
      {:get_value, caller} ->
        send(caller, value) #No modificar.
      #Aquí se pueden definir más mensajes.
      {:agreement, _, _, new_value} ->
        loop(:active, new_value, miss_prob)
    after
      1000 -> :ok #Aquí analizar porqué está esto aquí.
    end
    case state do
      :start ->
        chosen = :rand.uniform(10000)
        if(rem(chosen, miss_prob) == 0) do
          loop(:fail, chosen, miss_prob)
        else
          loop(:active, chosen, miss_prob)
        end
      :fail -> loop(:fail, value, miss_prob)
      :active -> loop(:active, value, miss_prob)
      #Aquí va su código.
    end
  end

  defp loop2() do
    receive do
      # Mensaje que solo hacen los padres de los principales
      {:init, tree, i, n} ->
        l = 2*i+1 
        r = 2*i+2
        p = div(i-1, 2)

        # Lamda que obtiene el valor de un proceso
        get_val = fn x ->
          if x do
            send(x, {:get_value, self()})
            receive do value -> value after 1000 -> :fail end
          else
            :fail
          end
        end

        # Verifica que hijos son procesos y pide su valor
        cond do
          l >= n-1 -> 
            value1 = get_val.(Map.get(tree, l))
            value2 = get_val.(Map.get(tree, r))
            cond do
              n < 3 -> 
                Map.get(tree, l) |> send({:agreement, tree, l, min(value1, value2)})
                if r < 2*n-1, do: Map.get(tree, r) |> send({:agreement, tree, r, min(value1, value2)})
              true -> 
                Map.get(tree, p) |> send({:consensus, tree, p, min(value1, value2)})
            end
        r >= n-1 ->
          value = get_val.(Map.get(tree, r))
          Map.get(tree, p) |> send({:consensus, tree, p, value})
        true -> :ok
      end
      loop2()

      # Mensaje hacia arriba (convergecast)
      {:consensus, tree, i, value1} ->
        receive do  
          {:consensus, _, _, value2} ->
            value = min(value1, value2)
            case i do
              0 -> 
                l = Map.get(tree, 1)
                r = Map.get(tree, 2)
                send(l, {:agreement, tree, 1, value})
                if r, do: send(r, {:agreement, tree, 2, value})

              _ -> 
                p = div(i-1, 2)
                Map.get(tree, p) |> send({:consensus, tree, p, value})
            end
        end
        loop2()    

      # Mensajes hacia abajo (broadcast)
      {:agreement, tree, i, value} ->
        l = Map.get(tree, 2*i+1)
        r = Map.get(tree, 2*i+2)
        send(l, {:agreement, tree, 2*i+1, value})
        if r, do: send(r, {:agreement, tree, 2*i+2, value})

    end
  end

  defp create_tree(processes, tree, pos) do
    case processes do
      [] -> tree
      [pid|l] -> create_tree(l, Map.put(tree, pos, pid), pos+1)
    end
  end

  def consensus(processes) do
    n = length(processes)
    if n > 1 do
      tree = create_tree(Enum.map(1..n-1, fn _ -> spawn(fn -> loop2() end) end), %{}, 0)
      tree = create_tree(processes, tree, n-1)
      Enum.map(0..n-2, fn i -> Map.get(tree, i) |> send({:init, tree, i, n}) end)
    end
    Process.sleep(10000)
    #Aquí va su código, deben de regresar el valor unánime decidido
    #por todos los procesos.

    vals = Enum.map(processes, fn x -> 
        send(x, {:get_value, self()})
        receive do y -> y after 1000 -> :fail end
        end
      )
      |> Enum.reject(&(&1 == :fail))

    if length(vals) > 0 do
      Enum.at(vals, 0)
    end
  end
end
