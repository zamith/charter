defmodule Charter.Chart do
  # TODO: Do the calculations based on a standard value, and only
  # scale later or else the margins won't make sense
  defstruct data: %{},
    title: "",
    width: 800,
    height: 800 * 0.75,
    raw_width: 800,
    raw_heigth: 800 * 0.75,
    scale: 1,
    colors: ["blue"],
    font_color: "black",
    background_color: "white",
    maximum_value: nil,
    minimum_value: nil,
    default_margin: 20,
    title_margin: 40,
    metadata: %Charter.Setup{}

    def theme(chart, name) do
      theme = Charter.Themes.theme(name)
      %{
        chart |
          colors: theme.colors,
          font_color: theme.font_color,
          background_color: theme.background_color,
      }
    end

    def color_for_column(chart, index) do
      scaled_index = rem(index, length(chart.colors))
      Enum.at(chart.colors, scaled_index)
    end
end
