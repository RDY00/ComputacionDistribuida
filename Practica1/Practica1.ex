defmodule Module1 do

  def fibonacci(n) do
    case n do
      0->0
      1->1
      _-> if n<0 do
          "No es posible N<0"
          else
            fibonacci(n-2)+fibonacci(n-1)
          end
      end
  end

  def factorial(n) do
    case n do
      0 -> 1
      1 -> 1
      _ -> if n<0 do
        "No es posible N<0"
        else
          n*factorial(n-1)
        end
      end
  end

  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.

    #numero = :rand.uniform(n)
    #if(n-numero) == 0 do
    #  0
    #else
      #1/(n-numero)
    #end
    numero =:rand.uniform(n)
    if (n-numero) == 0 do
      0
    else
      1/(n-numero)
    end
  end

  def digits(n) do
    s=to_string(n)
    s <> <<0>>
  end

end


defmodule Module3 do

  def rev(l) do
    case l do
      [] -> []
      [h | t] -> rev(t) ++ [h]
    end
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
