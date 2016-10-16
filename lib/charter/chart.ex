defmodule Charter.Chart do
  # TODO: Do the calculations based on a standard value, and only
  # scale later or else the margins won't make sense
  defstruct data: %{},
    title: "",
    width: 800,
    colors: ["blue"],
    maximum_value: nil,
    minimum_value: nil,
    default_margin: 20,
    title_margin: 40,
    metadata: %Charter.Setup{}

    def theme(chart, name) do
      %{chart | colors: Charter.Themes.theme(name).colors}
    end

    def color_for_column(chart, index) do
      scaled_index = rem(index, length(chart.colors))
      Enum.at(chart.colors, scaled_index)
    end
end
