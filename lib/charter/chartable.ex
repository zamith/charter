defmodule Charter.Chartable do
  defmacro __using__(_opts) do
    quote do
      def size(chartable, width) do
        update_chart(chartable, width: width)
      end

      def add_color(chartable, color) do
        update_chart(chartable,  colors: [color | chartable.chart.colors])
      end

      def data(chartable, name, data_points) do
        update_chart(chartable, data: Map.put(chartable.chart.data, name, data_points))
      end

      def title(chartable, title) do
        update_chart(chartable, title: title)
      end

      def theme(chartable, name) do
        %{chartable | chart: Charter.Chart.theme(chartable.chart, name)}
      end

      def create_image(%Mogrify.Image{}=image) do
        image
        |> Mogrify.create(path: ".")
      end

      def write(chartable, filename) do
        construct_image(chartable, filename)
        |> create_image
      end
    end
  end
end
