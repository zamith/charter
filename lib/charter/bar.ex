defmodule Charter.Bar do
  defstruct chart: %Charter.Chart{}

  def width(bar, width) do
    update_chart(bar, width: width)
  end

  def add_color(bar, color) do
    update_chart(bar,  colors: [color | bar.chart.colors])
  end

  def data(bar, name, data_points) do
    update_chart(bar, data: Map.put(bar.chart.data, name, data_points))
  end

  def title(bar, title) do
    update_chart(bar, title: title)
  end

  def write(bar, filename) do
    %Mogrify.Image{path: filename}
    |> Mogrify.custom("size", "#{bar.chart.width}x#{bar.chart.width}")
    |> Mogrify.canvas("white")
    |> Charter.Draw.title(bar.chart)
    |> Mogrify.create(path: ".")
  end

  defp update_chart(bar, updates) do
    %Charter.Bar {
      chart: Map.merge(bar.chart, Enum.into(updates, %{}))
    }
  end
end
