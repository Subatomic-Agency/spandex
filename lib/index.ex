defmodule Spandex.Index do
  defstruct [:module, :mapping]

  defmacro __using__(_) do
    quote do
      @behaviour Spandex.Behaviour.Index
      def reference() do
        %Spandex.Index{
          mapping: __MODULE__.mapping(),
          module: __MODULE__
        }
      end

      def maps_to() do
        application =
          Application.get_env(:spandex, :namespace)
          |> Atom.to_string()
          |> Macro.camelize()

        type = base_name()

        Module.concat([
          application,
          Macro.camelize(type),
          Inflex.singularize(Macro.camelize(type))
        ])
      end

      def base_name() do
        __MODULE__
        |> Module.split()
        |> List.last()
        |> Macro.underscore()
        |> Inflex.pluralize()
      end

      def settings(), do: %{}

      defoverridable settings: 0, base_name: 0, maps_to: 0
    end
  end
end
