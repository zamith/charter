defmodule Charter.Chart do
  defstruct data: %{},
    title: "",
    width: 800,
    colors: [],
    maximum_value: nil,
    minimum_value: nil,
    default_margin: 20,
    metadata: %Charter.Setup{}
end
