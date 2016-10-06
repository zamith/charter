defmodule Charter.Draw do
  def title(image, chart) do
    image
    |> Mogrify.custom("fill", "blue")
    |> Mogrify.custom("stroke", "transparent")
    |> Mogrify.custom("gravity", "North")
    |> Mogrify.Draw.text(0, 20, chart.title)
  end
end
