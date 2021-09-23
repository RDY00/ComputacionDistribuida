defmodule Consensus do

  def create_consensus(n) do
    #Crear n hilos pero cada uno de esos hilos va
    #a escoger un número completamente al azar.
    #El deber del estudiante es completar la función loop
    #para que al final de un número de ejecuciones de esta,
    #todos los hilos tengan el mismo número, el cual va a ser enviado vía un
    #mensaje al hilo principal.
    Enum.map(1..n, fn _ -> spawn(fn -> loop(:start), end) end)
  end

  defp loop(value) do
    case value do
      :start -> loop(value(:rand.uniform(10000)))
      #Aquí va su código.
    end
    receive do
      {:get_value, caller} ->
	send(caller, value)
	loop(value)
    end
  end

  def consensus(processes) do
    Process.sleep(5000)
    #Aquí va su código.
    :ok
  end
  
end
