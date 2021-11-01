defmodule Spandex.Behaviour.Index do
  @type index_mapping :: %{properties: map}
  @type(index_generator_list :: %{index: %{_id: integer}}, map)

  @callback base_name() :: String.t()
  @callback maps_to() :: Ecto.Schema.t()

  @callback mapping() :: index_mapping
  @callback settings() :: map
  @callback generator(String.t()) :: [index_generator_list]
  @callback updater(Ecto.Schema.t(), String.t()) :: [index_generator_list]
end
