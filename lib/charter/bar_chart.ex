defmodule Charter.BarChart do
  defstruct chart: %Charter.Chart{},
    bar_width: 50,
    bar_spacing_factor: 0.9

  alias Charter.BarChart
  alias Charter.Chart

  def size(%BarChart{}=bar, width) do
    update_chart(bar, width: width)
  end

  def add_color(%BarChart{}=bar, color) do
    update_chart(bar,  colors: [color | bar.chart.colors])
  end

  def data(%BarChart{}=bar, name, data_points) do
    update_chart(bar, data: Map.put(bar.chart.data, name, data_points))
  end

  def title(%BarChart{}=bar, title) do
    update_chart(bar, title: title)
  end

  def theme(%BarChart{}=bar, name) do
    %{bar | chart: Chart.theme(bar.chart, name)}
  end

  def construct_image(%BarChart{}=bar, filename) do
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

  def write(%BarChart{}=bar, filename) do
    construct_image(bar, filename)
    |> create_image
  end

  defp update_chart(bar, updates) do
    %BarChart {
      chart: Map.merge(bar.chart, Enum.into(updates, %{}))
    }
  end

  defp draw_bars(image, bar) do
    chart = bar.chart
    Enum.reduce(chart.data, image, fn ({_series_name, values}, previous_image) ->
      Enum.reduce(values, {previous_image, 0}, fn (value, {previous_image, index}) ->
        left_x = chart.default_margin + (bar.bar_width * (index + (chart.metadata.column_count - 1))) + padding(bar)
        right_x = left_x + bar.bar_width * bar.bar_spacing_factor
        {left_y, right_y} = scaled_y_values(bar, value)

        new_image = previous_image
          |> Mogrify.custom("fill", Chart.color_for_column(bar.chart, index))
          |> Mogrify.Draw.rectangle(left_x, left_y, right_x, right_y)

        {new_image, index + 1}
      end)
      |> elem(0)
    end)
  end

  defp scaled_y_values(bar, value) do
    factor = ((value * 100) / bar.chart.metadata.maximum_value) / 100
    left_y = bar.chart.width
    right_y = (bar.chart.width * (1 - factor)) + bar.chart.title_margin
    {left_y, right_y}
  end

  defp padding(bar) do
    (bar.bar_width * (1 - bar.bar_spacing_factor)) / 2
  end
end
