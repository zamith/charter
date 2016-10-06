defmodule Charter do
  import Mogrify
  import Charter.Bar

  def bar do
    %Charter.Bar{}
    |> data(:Jimmy, [20,25,30])
    |> data(:Mary, [30,25,50])
    |> title("Hello World!")
    |> write("bar.png")
  end

  def draw do
    %Mogrify.Image{path: "test.png", ext: "png"}
    |> custom("size", "280x280")
    |> canvas("white")
    |> custom("fill", "blue")
    |> custom("draw", "path 'M 120,140  L 120,40  A 100,100 0 0,1 137.36,41.52  Z'")
    |> create(path: ".")
  end

  def circle do
    %Mogrify.Image{path: "test.png", ext: "png"}
    |> custom("size", "280x280")
    |> canvas("white")
    |> custom("fill", "blue")
    |> Mogrify.Draw.circle(140,140,100,100)
    |> custom("fill", "yellow")
    |> Mogrify.Draw.circle(140,140,140,100)
    |> create(path: ".")
  end
end
