defmodule Module1 do
  @moduledoc """
  Module1: Funciones básicas.
          * Fibonacci
	  * Factorial
	  * Random
	  * Digits?
  """
  
  @doc """
  fibonacci: Implementación recursiva del n-esimo
             termino de la serie de fibonacci.
	     
  fibonacci(0) = 0
  fibonacci(sucesor(0)) = sucesor(0)
  fibonacci(sucesor(sucesor(n))) = fibonacci(sucesor(n)) +
                                   fibonacci(n)
  """
  def fibonacci(0) do
    0
  end

  def fibonacci(1) do
    1
  end
  
  def fibonacci(n) do
    fibonacci(n-1)+fibonacci(n-2)
  end

  @doc """
  factorial: Implementación recursiva del factorial.
  
  factorial(0) = 1
  factorial(sucesor(n)) = sucesor(n)*factorial(n)
  """
  def factorial(0) do
    1
  end
    
  def factorial(n) do
    n*factorial(n-1)
  end

  @doc """
  random_probability: Dado [1, 2, ..., k, ..., n] para alguna numero natural 
                      aleatorio k menor o igual a n, la función
		      determina la probabilidad de elegir algún número x 
		      tal que k <= x <= n.
  """
  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.
    k = :rand.uniform(n)
    IO.puts("[#{k},..., #{n}]")
    (n-k+1)/n
  end

  @doc """
  digits: ?
  """
  def digits(n) do
    n
  end

end

defmodule Module2 do
  @moduledoc """
  Module2: 
          * test/0
	  * solve/3
  """
  
end

defmodule Module3 do

  def rev(l) do
    l
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
