defmodule Charter.BarChart do
  defstruct chart: %Charter.Chart{},
    bar_width: 50,
    bar_spacing_factor: 0.9

  alias Charter.BarChart
  alias Charter.Chart

  use Charter.Chartable

  def construct_image(%BarChart{}=bar, filename) do
    bar = update_chart(bar, metadata: Charter.Setup.calculate_metadata(bar.chart))
    # TODO: Figure out how to calculate size properly, it doesn't always
    # have to be a square
    %Mogrify.Image{path: filename}
    |> Mogrify.custom("size", "#{bar.chart.width}x#{bar.chart.height}")
    |> Mogrify.canvas(bar.chart.background_color)
    |> Charter.Draw.title(bar.chart)
    |> draw_bars(bar)
  end

  defp update_chart(bar, updates) do
    %BarChart {
      chart: Map.merge(bar.chart, Enum.into(updates, %{}))
    }
  end

  defp draw_bars(image, bar) do
    chart = bar.chart
    Enum.reduce(chart.data, image, &(draw_series(bar, &1, &2)))
  end

  defp draw_series(bar, {_series_name, values}, image) do
    Enum.reduce(values, {image, 0}, &(draw_column(bar, &1, &2)))
    |> elem(0)
  end

  defp draw_column(bar, value, {image, index}) do
    left_x = bar.chart.default_margin + (bar.bar_width * (index + (bar.chart.metadata.column_count - 1))) + padding(bar)
    right_x = left_x + bar.bar_width * bar.bar_spacing_factor
    {left_y, right_y} = scaled_y_values(bar, value)

    new_image = image
      |> Mogrify.custom("fill", Chart.color_for_column(bar.chart, index))
      |> Mogrify.Draw.rectangle(left_x, left_y, right_x, right_y)

    {new_image, index + 1}
  end

  defp scaled_y_values(bar, value) do
    factor = ((value * 100) / bar.chart.metadata.maximum_value) / 100
    left_y = bar.chart.raw_width
    right_y = (bar.chart.raw_width * (1 - factor)) + bar.chart.title_margin
    {left_y, right_y}
  end

  defp padding(bar) do
    (bar.bar_width * (1 - bar.bar_spacing_factor)) / 2
  end
end
