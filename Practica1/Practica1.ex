defmodule Module1 do

  @doc """
    Implementación de fibonacci. Para esta función se uso case, para saber
    cual saber que caso debe aplicar de la función recursiva. Esto por que
    necesitamos llegar a los casos base.

    (Se pudo implementar también con casa de patrones directo a las funcio-
    nes.)

    Adicionalmente checa que la entrada sea un número y que sea positivo.
  """
  def fibonacci(n) do
    case n do
      0 -> 0
      1 -> 1
      n ->
        if n > 1 && is_number(n) do
          fibonacci(n-1) + fibonacci(n-2)
        else
          IO.puts("La entrada #{inspect n} es inválida.")
          :error
        end
    end
  end

  @doc """
    El factorial de n, es el producto de los n números.

    Se implemento usando casa de patrones, donde según la entrada cazará con
    alguna de las definiciones para la función.

    Se definio el caso para 0 y para 1. Convencionalmente 1, es el caso base,
    pero si solo definimos este caso, quedaría indefinido el 0.

    Para el caso de n, hace la misma evaluación que en el caso anterior.
  """
  def factorial(0), do: 1
  def factorial(1), do: 1
  def factorial(n) do
    if n > 1 && is_number(n) do
      n * factorial(n-1)
    else
      IO.puts("La entrada #{inspect n} es inválida.")
      :error
    end
  end

  @doc """
    Obtiene un número aleatorio entre el 1 y el n.

    Calcula cual es la probabilidad de cada uno de los números en ese rango
    prob_num. Entonces calcula cual es la probabilidad de aparición de todo
    el rango [k .. n].
  """
  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.
    k = :rand.uniform(n)
    IO.puts("Número aleatorio seleccionado: #{inspect k}")
    prob_num = 1 / n
    prob_k = ((n - k) * prob_num) + 0.1
    IO.puts("La probabilidad de que salga un número entre k y n es de #{inspect prob_k}")
  end

  def digits(n) do
    :ok
  end

end


defmodule Module3 do

  def rev(l) do
    :ok
  end

  def sieve_of_erathostenes(n) do
    :ok
  end

end

defmodule Module4 do

  def monstructure() do
    :ok
  end

end
