import GeneratePackage


defmodule SlidingWindow do

  def new(n) do
    package = generate_package(n)
    k = :rand.uniform(div(n, 2))
  end
  
end
