defmodule Charter.Setup do
  defstruct column_count: 0,
    maximum_value: nil,
    minimum_value: nil,
    graph_top: 0,
    rows: 0,
    columns: 0

  def calculate_metadata(%Charter.Chart{}=chart) do
    {max, min} = find_extremes(chart)

    %Charter.Setup{
      column_count: column_count(chart),
      maximum_value: max,
      minimum_value: min,
      graph_top: calculate_graph_top(chart),
      rows: rows(chart),
      columns: chart.width,
    }
  end

  defp column_count(chart) do
    chart.data |> Map.keys |> length
  end

  # defp calculate_spread(chart) do
  #   spread = chart.maximum_value/1 - chart.minimum_value/1
  #   if spread > 0 do spread else 1 end
  # end

  def find_extremes(chart) do
    chart.data
    |> Enum.reduce({chart.maximum_value, chart.minimum_value}, fn({_series_name, data_points}, {max, min}) ->
      Enum.reduce(data_points, {max, min}, fn(data_point, acc) ->
        extremes(data_point, acc)
      end)
    end)
  end

  defp extremes(data_point, {max, min}) when is_nil(max) and is_nil(min), do: {data_point, data_point}
  defp extremes(data_point, {max, min}) when data_point > max, do: {data_point, min}
  defp extremes(data_point, {max, min}) when data_point < min, do: {max, data_point}
  defp extremes(_data_point, {max, min}), do: {max, min}

  defp calculate_graph_top(chart) do
    chart.default_margin
  end

  def rows(chart) do
    chart.width * 0.75
  end
end

