defmodule Spandex.Index do
  defstruct [:type, :module, :mapping]

  defmacro __using__(_) do
    quote do
      @behaviour Spandex.Behaviour.Index
      def reference() do
        module =
          __MODULE__
          |> Module.split()
          |> List.last()

        %Spandex.Index{
          mapping: __MODULE__.mapping(),
          module: __MODULE__,
          type: Macro.underscore(module)
        }
      end

      def settings(), do: %{}

      defoverridable settings: 0
    end
  end
end
