defmodule Charter.Themes do
  def theme(:keynote) do
    %{
      colors: [
        '#FDD84E',  # yellow
        '#6886B4',  # blue
        '#72AE6E',  # green
        '#D1695E',  # red
        '#8A6EAF',  # purple
        '#EFAA43',  # orange
        'white',
      ],
      font_color: "white",
      background_color: "black",
    }
  end
end
