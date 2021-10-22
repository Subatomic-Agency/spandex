defmodule Spandex.Serializer do
  def serialize(results) when is_list(results) do
    Enum.reduce(results, [], fn result, acc ->
      acc ++ [serialize(result)]
    end)
  end

  def serialize(%{"_source" => source, "_index" => index}) do
    type =
      index
      |> deprefix()
      |> desuffix(Mix.env())

    index_module = Spandex.indices() |> Enum.find(&(&1.base_name() == type))
    module = index_module.maps_to()

    schema_fields = for key <- module.__schema__(:fields), into: [], do: to_string(key)
    es_fields = Map.keys(source)

    matched_fields_for_struct =
      Enum.filter(
        es_fields,
        fn es_field ->
          Enum.member?(schema_fields, es_field)
        end
      )

    meta_fields = es_fields -- schema_fields

    map_for_struct =
      for {key, val} <- Map.take(source, matched_fields_for_struct),
          into: %{},
          do: {String.to_existing_atom(key), val}

    struct = struct(module, map_for_struct)

    %{struct: struct, meta: Map.take(source, meta_fields)}
  end

  defp deprefix(name) do
    [_lang, type] = String.split(name, "_", parts: 2)

    type
  end

  defp desuffix(name, :test), do: String.replace_suffix(name, "_test", "")
  defp desuffix(name, _), do: name
end
