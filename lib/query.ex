defmodule Spandex.Query do
  defstruct [:query, :index, :ecto_object, language: "en", action: :search]

  def compile(thing, params \\ %{})

  def compile(query_map, params) when is_struct(query_map) and is_map(params) do
    struct(
      %Spandex.Query{},
      Map.merge(params, %{query: query_map, index: query_map.index.reference()})
    )
  end

  def compile(index_module, params) when is_map(params) do
    struct(
      %Spandex.Query{},
      Map.merge(params, %{query: %{}, index: index_module.reference()})
    )
  end
end
