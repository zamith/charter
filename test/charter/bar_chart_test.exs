defmodule Charter.BarChartTest do
  import Charter.BarChart

  use ExUnit.Case, async: true

  test "default chart" do
    image = %Charter.BarChart{}
      |> construct_image("fake.png")

    assert find_operation(image, :image_operator) |> String.contains?("xc:")
    assert find_operation(image, "size") != nil
  end

  test ".title" do
    title = "Important Chart"
    image = %Charter.BarChart{}
      |> title(title)
      |> construct_image("fake.png")

    assert find_operation(image, "draw")
      |> String.contains?(title)
  end

  def find_operation(image, operation) do
    Enum.find(image.operations, fn({name, value}) ->
      name == operation
    end)
    |> elem(1)
  end
end
