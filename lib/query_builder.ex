defmodule Spandex.QueryBuilder do
  defmacro __using__(index: index) do
    quote bind_quoted: [index: index] do
      def new(args \\ %{}) do
        args =
          args
          |> Map.merge(%{index: unquote(index)})
          |> Enum.into([])

        struct(__MODULE__, args)
      end
    end
  end
end
