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
    n * factorial(n-1)
  end

  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.
    k = :rand.uniform(n) # Numero alearotorio entre 1 y n
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
    fn -> :ok end
  end

  def solve(a, b, n) do
    {g,x,_} = mcde(a,n)

    if rem(b,g) == 0 do
      mod(x * div(b,g), n) # Para que la respuesta este entre 0 y n-1
    else
      :error
    end

  end

  # Modulo para funcionar con negativos y 0
  defp mod(x,y) when x > 0, do: rem(x,y);
  defp mod(x,y) when x < 0, do: rem(x,y) + y;
  defp mod(0,_), do: 0;

  # IMPLEMENTADO DENTRO DE mcde
  #  # funcion para encontrar el maximo comun divisor
  #  defp mcd(a, 0) do
  #    abs(a)
  #  end
  #
  #  defp mcd(a, b) do
  #    mcd(b, rem(a,b))
  #  end

  # Algoritmo Extendido de Euclides
  # Devuelve una tupla {mcd(a,b), x, y} donde x y y
  # cumplen que ax + by = mdc(a,b)
  defp mcde(a, b) do
    case {a,b} do
      {0,b} -> {b,0,1}
      {a,b} -> 
        {g,x,y} = mcde(rem(b,a), a)
        {g, y - div(b,a) * x, x}
    end
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

  defp sieve_of_erathostenes([x|xs], n) do
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
    spawn(fn -> monstructure([], {}, MapSet.new(), %{}) end)
  end

  # monstructure con las estructuras de datos
  # l: Lista, t: Tupla, ms: MapSet, m: Map
  defp monstructure(l, t, ms, m) do
    receive do
      # MENSAJES DE LAS LISTAS ----------------------------

      # Agregar elemento al final
      {:put_list, n} ->
        monstructure(l ++ [n], t, ms, m)

      # Enviar tamaño a quien lo pidio
      {:get_list_size, sender} ->
        send(sender, {:list_size, list_size(l)})
        monstructure(l, t, ms, m)

      # Eliminar e de l (Solo elimina la primera instancia de izquierda a derecha)
      {:rem_list, e} ->
        monstructure(remove_from_list(l,e), t, ms, m)

      # MENSAJES DE LAS TUPLAS ----------------------------

      # Devuelve la tupla
      {:get_tuple, sender} ->
        send(sender, {:tuple_get, t})
        monstructure(l, t, ms, m)

      # Devuelve la tupla como lista
      {:tup_to_list, sender} ->
        send(sender, {:tuple_as_list, Tuple.to_list(t)})
        monstructure(l, t, ms, m)

      # Agrega elemento al final de la tupla (Crea otra)
      {:put_tuple, n} ->
        monstructure(l, Tuple.append(t,n), ms, m)

      # MENSAJES DE LOS MAPSETS ---------------------------

      # Revisa si e esta en ms y lo devuelve
      {:mapset_contains, e, sender} ->
        send(sender, {:contains_mapset, MapSet.member?(ms,e)})
        monstructure(l, t, ms, m)

      # Agrega e a ms
      {:mapset_add, e} ->
        monstructure(l, t, MapSet.put(ms,e), m)
      
      # Devuelve el tamaño de ms
      {:mapset_size, sender} ->
        send(sender, {:size_mapset, mapset_size(ms)})
        monstructure(l, t, ms, m)

      # MENSAJES DE LOS MAPS ------------------------------

      # Agrega e con llave k en m
      {:map_put, k, e} ->
        monstructure(l, t, ms, Map.put(m,k,e))

      # Envia el elemento con llave k
      {:map_get, k, sender} ->
        send(sender, {:get_map, Map.get(m,k)})
        monstructure(l, t, ms, m)

      # Cambia el elemento con llave k por aplicar 
      {:map_lambda, k, f, b} ->
        a = Map.get(m,k)
        new_elem = f.(a,b)
        monstructure(l, t, ms, Map.put(m,k,new_elem))
      
      _ -> 
        :error
        monstructure(l, t, ms, m)
        
    end
  end

  # FUNCIONES AUXILIARES PARA LISTAS ---------------------------------------

  # Remueve de l la primera instancia de e, si existe, y
  # regresa la lista modificia, y e no esta, devuelve l
  defp remove_from_list(l, e) do
    case l do
      [] -> []
      [x | xs] when x == e -> xs
      [x | xs] -> [x | remove_from_list(xs, e)]
    end
  end

  # Devuelve el tamaño de una lista
  defp list_size(l) do
    case l do
      [] -> 0
      [_ | xs] -> 1 + list_size(xs)
    end
  end

  # FUNCIONES AUXILIARES PARA MAPSETS ---------------------------------------

  # Devuelve el tamaño del MapSet
  defp mapset_size(ms) do
    list_size(for x <- ms, do: x)
  end

end