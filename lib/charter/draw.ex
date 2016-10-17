defmodule Charter.Draw do
  def title(image, chart) do
    image
    |> Mogrify.custom("fill", chart.font_color)
    |> Mogrify.custom("stroke", "transparent")
    |> Mogrify.custom("gravity", "North")
    |> Mogrify.Draw.text(0, chart.default_margin, chart.title)
  end
end
