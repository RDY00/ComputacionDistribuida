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
    :ok
  end

  #* Era igual que agregar, por eso las uni en una sola -- Fer UmU
  defp create_tree(processes, tree, pos) do
    case processes do
      [] -> tree
      [pid|l] -> create_tree(l, Map.put(tree, pos, pid), (pos+1))
  end

  def consensus(processes) do
    n = length(processes)
    tree = create_tree(Enum.map(1..n-1, fn _ -> spawn(fn -> loop2() end) end), %{}, 0)
    tree = create_tree(processes, tree, n-1)
    Process.sleep(10000)
    #Aquí va su código, deben de regresar el valor unánime decidido
    #por todos los procesos.
  end

end
