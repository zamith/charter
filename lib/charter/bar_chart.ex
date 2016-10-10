defmodule Charter.BarChart do
  defstruct chart: %Charter.Chart{},
    bar_width: 50,
    bar_spacing_factor: 0.9

  def width(%Charter.BarChart{}=bar, width) do
    update_chart(bar, width: width)
  end

  def add_color(%Charter.BarChart{}=bar, color) do
    update_chart(bar,  colors: [color | bar.chart.colors])
  end

  def data(%Charter.BarChart{}=bar, name, data_points) do
    update_chart(bar, data: Map.put(bar.chart.data, name, data_points))
  end

  def title(%Charter.BarChart{}=bar, title) do
    update_chart(bar, title: title)
  end

  def construct_image(%Charter.BarChart{}=bar, filename) do
    bar = update_chart(bar, metadata: Charter.Setup.calculate_metadata(bar.chart))
    %Mogrify.Image{path: filename}
    |> Mogrify.custom("size", "#{bar.chart.width}x#{bar.chart.width}")
    |> Mogrify.canvas("white")
    |> Charter.Draw.title(bar.chart)
    |> draw_bars(bar)
  end

  def create_image(%Mogrify.Image{}=image) do
    image
    |> Mogrify.create(path: ".")
  end

  def write(%Charter.BarChart{}=bar, filename) do
    construct_image(bar, filename)
    |> create_image
  end

  defp update_chart(bar, updates) do
    %Charter.BarChart {
      chart: Map.merge(bar.chart, Enum.into(updates, %{}))
    }
  end

  defp draw_bars(image, bar) do
    chart = bar.chart
    Enum.reduce(chart.data, image, fn ({series_name, values}, previous_image) ->
      Enum.reduce(values, {previous_image, 0}, fn (value, {previous_image, index}) ->
        left_x = chart.default_margin + (bar.bar_width * (index + (chart.metadata.column_count - 1))) + padding(bar)
        right_x = left_x + bar.bar_width * bar.bar_spacing_factor
        IO.inspect {left_y, right_y} = scaled_y_values(bar, value)
        IO.puts "####"

        new_image = previous_image
          |> Mogrify.custom("fill", "blue")
          |> Mogrify.Draw.rectangle(left_x, left_y, right_x, right_y)

        {new_image, index + 1}
      end)
      |> elem(0)
    end)
  end

  defp scaled_y_values(bar, value) do
    factor = ((value * 100) / bar.chart.metadata.maximum_value) / 100
    left_y = 800
    right_y = 800 * (1 - factor)
    {left_y, right_y}
  end

  defp padding(bar) do
    (bar.bar_width * (1 - bar.bar_spacing_factor)) / 2
  end
end
