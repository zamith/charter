# Charter

Charter is a simple to use chart generation library for Elixir. It is currently in a very early stage, so the functionality is limited, but the idea is to support a few different types of charts with multiple options and combinations.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `charter` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:charter, "~> 0.1.0"}]
    end
    ```

  2. Ensure `charter` is started before your application:

    ```elixir
    def application do
      [applications: [:charter]]
    end
    ```

## Usage

Here's a simple example of how to draw a bar chart, with some of the available options. 

```elixir
defmodule Charter do
  import Charter.BarChart

  def bar do
    %Charter.BarChart{}
    |> size(800)
    |> theme(:keynote)
    |> data(:series_name, [40,25,30])
    |> title("Hello World!")
    |> write("bar.png")
  end
end
```
