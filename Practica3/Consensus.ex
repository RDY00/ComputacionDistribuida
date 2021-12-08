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

  def loop2() do
    # TODO: Terminar funcion para procesos auxiliares del arbol
    # lamda que obtiene el valor de un proceso
    get_val = fn x ->
      if x do
        send(x, {:get_value, self()})
        receive do value -> value after 1000 -> :fail end
      else
        :fail
      end
    end

    receive do
      # Mensaje que solo hacen los padres de los principales
      {:init, tree, i} ->
        f_leaf = n - div(n, 2) - 1 # La ultima es n-1
        l = Map.get(tree, 2*i+1)
        r = Map.get(tree, 2*i+2)
        p = div(i-1, 2)

        if f_leaf <= i && i < n do
          val1 = get_val.(l)
          val2 = get_val.(r)
          Map.get(p) |> send({:consensus, tree, p, min(value1, value2)})

      # Mensaje hacia arriba (convergecast)
      {:consensus, tree, i, value1} ->
        receive do  
          {:consensus, tree, value2} ->
            value = min(value1, value2)
            case i do
              0 -> 
                l = Map.get(tree, 1)
                r = Map.get(tree, 2)

                send(l, {:agreement, tree, 1, value})
                if r, do: send(r, {:agreement, tree, 2, value})

              _ -> 
                p = div(i-1, 2)
                Map.get(p) |> send({:agreement, tree, p, value})
            end
        end

      # Mensajes hacia abajo (broadcast)
      {:agreement, tree, i, value} ->
        l = Map.get(tree, 2*i+1)
        r = Map.get(tree, 2*i+2)
        send(l, {:agreement, tree, 2*i+1, value})
        if r, do: send(r, {:agreement, tree, 2*i+2, value})

    end
    loop2()    
  end

  #* Era igual que agregar, por eso las uni en una sola -- Fer UmU
  defp create_tree(processes, tree, pos) do
    case processes do
      [] -> tree
      [pid|l] -> create_tree(l, Map.put(tree, pos, pid), (pos+1))
  end

  def consensus(processes) do
    n = length(processes)
    tree = create_tree(Enum.map(0..n, fn _ -> spawn(fn -> loop2() end) end), %{}, 0)
    tree = create_tree(processes, tree, n-1)
    Enum.each(0..n, fn i -> Map.get(i) |> send({:init, tree, i}) end)
    Process.sleep(10000)
    #Aquí va su código, deben de regresar el valor unánime decidido
    #por todos los procesos.
  end

end
