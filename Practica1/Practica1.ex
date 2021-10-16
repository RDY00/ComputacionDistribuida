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

  @doc """
    Va a separar los digitos del número.

    Primero, vérifica que la entrada sea un número.

    Luego, sí el número es negativo, va a añadir un atómico que represente
    el signo - y va a continuar su ejecución con el valor absoluto del nú-
    mero.

    Si el número ya es un digito, es decir n < 10. Devuelve la lista con
    ese dígito (Se tuvo que implementar la conversión, por que, al meter
    n a la lista, Elixir lo transformaba automáticamente a ASCII).

    Si el número aún no es un digito. Va a separar el último dígito del
    número (que va a caer en el caso base), y va a separar el resto del
    número. Así hará recursión sobre ambos,  concatenará la lista que
    obtenga de esta llamada.
  """
  def digits(n) do
    cond do
      ! is_number(n) ->
        IO.puts("#{inspect n} no es un número.")
        :error
      n < 0 ->
        [:-] ++ digits(abs(n))
      n < 10 ->
        n = Integer.to_string(n)
        n = Integer.parse(n)
        {var, _} = n
        [var]
      n ->
        digits(div(n,10)) ++ digits(rem(n,10))
    end
  end

end

defmodule Module2 do

  @doc """
    Función test.
  """
  def test do
    fn -> end
    :ok
  end

  @doc """
    Función auxiliar quecalcula el MCD mediante una implementación del Al-
    goritmo de Euclides.
  """
  defp mcd(x,y) do
    case y do
      0 -> x
      y -> mcd(y,rem(x,y))
    end
  end

  @doc """
    La forma en la que podemos saber si la ecuación a x ~= b mod n. Es caculando el mcd de a y n, si
    este es 1, significa que a y n son primos relativos y por lo tanto tienen solución. En otro caso
    significa que no son primos relativos y que la ecuación no tiene solución.

    Para esto, se usará la función auxiliar.

    (~= representa el símbolo de congruencia).
  """
  def solve(a,b,n) do
    if mcd(a,n) == 1 do
      "La ecuación #{inspect a} x ~= #{inspect b} mod #{inspect n} tiene solución."
    else
      "La ecuación #{inspect a} x ~= #{inspect b} mod #{inspect n} no tiene solcuión."
    end
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
