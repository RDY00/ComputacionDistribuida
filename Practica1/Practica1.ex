defmodule Module1 do

  # Fibonacci ---------------------------
  def fibonacci(n) do
    if n < 0 do # No se aceptan negativos
      :error
    end

    if n < 2 do
      n # Casos Base
    else
      fibonacci(n-1) + fibonacci(n-2) # Caso Recursivo
    end
  end

  # Factorial ---------------------------
  # Con caza de patrones
  def factorial(0) do # Caso Base
    1
  end

  def factorial(n) do # Caso recursivo
    n * (n-1)
  end

  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.
    k = :random.uniform(n) # Numero alearotorio entre 1 y n
    (n-k+1) / n # La proba deseada
  end

  def digits(n) do
    if n < 0 do # Si es negativo, cambiamos el signo
      digits(-1*n)
    end

    d = div(n,10) # Division entera entre 1 (Como quitar la unidad)
    r = rem(n,10) # Residuo entre 10 (Nos da la unidad que quitamos)

    if d == 0 do
      [r] # Si d es 0, n ya es un digito y r = n
    else
      # Si no, tiene al menos dos, r es la unidad de n y d el resto
      # Aplicamos recursividad con d
      digits(d) ++ [r]
    end
  end

end


defmodule Module2 do

  # funcion llamada test/0, el cual cree una funcion lambda y regrese un :ok
  def test() do
    fn () -> :ok end
  end

  def solve(a, b, n) do
    case mcd(a,n) do
      1 -> :ok
      _ -> :error
    end
  end

  # funcion para encontrar el maximo comun divisor
  defp mcd(a, 0) do
    abs(a)
  end

  defp mcd(a, b) do
    mcd(b, rem(a,b))
  end

end

defmodule Module3 do

  def rev(l) do
    case l do
      [] -> [] # Caso base
      [x|xs] -> rev(xs) ++ [x] # Caso recursivo
    end
  end

  def elim_dup(l) do
    case l do
      [] -> []
      [x|xs] -> [x | (for y <- elim_dup(xs), y != x, do: y)]
    end
  end

  def sieve_of_erathostenes(n) do
    sieve_of_erathostenes((for x <- 2..n, do: x), n)
  end

  def sieve_of_erathostenes([x|xs], n) do
    # Quitamos los multiplos de a de l = xs
    l = for i <- xs, rem(i,x) != 0, do: i

    # Si a^2 < n, aplicamos recursividad con la 
    # sublista que ya no tiene sus multiplos, si no
    # Devolvemos x y la lista sin los multiplos de x
    if x*x < n do
      [x | sieve_of_erathostenes(l, n)]
    else
      [x | l]
    end
  end

end

defmodule Module4 do

  def monstructure() do
    receive do
      m -> monstructure([], {}, MapSet.new(), %{})
    end
  end

  # monstructure con las estructuras de datos
  # l: Lista, t: Tupla, ms: MapSet, m: Map
  defp mostructure(l, t, ms, m) ->
    receive do
      # MENSAJES DE LAS LISTAS ----------------------------

      # Agregar elemento al final
      {:put_list, n} ->
        mostructure(l ++ [n], t, ms, m)

      # Enviar tamaño a quien lo pidio
      {:get_list_size, sender} ->
        send(sender, {:list_size, list_size(l)})
        mostructure(l, t, ms, m)

      # Eliminar e de l (Solo elimina la primera instancia de izquierda a derecha)
      {:rem_list, e} ->
        mostructure(remove_from_list(l,e), t, ms, m)

      # MENSAJES DE LAS TUPLAS ----------------------------

      # Devuelve la tupla
      {:get_tuple, sender} ->
        send(sender, {:tuple_get, t})
        mostructure(l, t, ms, m)

      # Devuelve la tupla como lista
      {:tup_to_list, sender} ->
        tupList = for x <- t, do: x
        send(sender, {:tup_to_list, tupList})
        mostructure(l, t, ms, m)

      # Agrega elemento al final de la tupla (Crea otra)
      {:put_tuple, n} ->
        mostructure(l, Tuple.append(t,n), ms, m)

        mostructure(l, t, ms, m)
      {:get_tuple, sender} ->
        mostructure(l, t, ms, m)
      {:get_tuple, sender} ->
        mostructure(l, t, ms, m)
      
    end
  end

  # FUNCIONES AUXILIARES PARA LISTAS ---------------------------------------

  # Remueve de l la primera instancia de e, si existe, y
  # regresa la lista modificia, y e no esta, devuelve l
  defp remove_from_list(l, e) do
    case l do
      [] -> []
      [e | xs] -> xs
      [x | xs] -> [x | remove_from_list(xs, e)]
    end
  end

  # Devuelve el tamaño de una lista
  defp list_size(l) do
    case l do
      [] -> 0
      [x | xs] -> 1 + list_size(xs)
    end
  end

end