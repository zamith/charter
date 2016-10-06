defmodule Charter.Setup do
  def calculate_spread(chart) do
    spread = chart.maximum_value/1 - chart.minimum_value/1
    if spread > 0 do spread else 1 end
  end

  defp find_extremes(chart) do
    chart.data
    |> Enum.reduce({chart.maximum_value, chart.minimum_value}, fn({series_name, data_points}, {max, min}) ->
      Enum.reduce(data_points, {max, min}, &extremes/2)
    end)
  end

  defp extremes(data_point, {max, min}) when is_nil(max) and is_nil(min), do: data_point
  defp extremes(data_point, {max, min}) when data_point > max, do: {data_point, max}
  defp extremes(data_point, {max, min}) when data_point < min, do: {max, data_point}
end

