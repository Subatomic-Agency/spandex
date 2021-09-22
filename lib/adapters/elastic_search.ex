defmodule Elastix.NewMapping do
  import Elastix.HTTP, only: [prepare_url: 2]
  alias Elastix.{HTTP, JSON}

  def put(elastic_url, index_name, _type, data) do
    prepare_url(elastic_url, "/#{index_name}/_mapping")
    |> HTTP.put(JSON.encode!(data))
  end
end

defmodule Spandex.Adapters.ElasticSearch do
  @spec search(map) :: {:ok, [Ecto.Schema.t()], integer} | {:error, %HTTPoison.Response{}}
  def search(query_map) do
    search_result =
      Elastix.Search.search(
        endpoint(),
        index_name(query_map),
        ["_doc"],
        %{
          from: 0,
          size: 10000,
          query: query_map.query.query
        }
      )

    case search_result do
      {:ok,
       %HTTPoison.Response{
         body: %{
           "hits" => %{
             "hits" => results,
             "total" => %{"value" => count}
           }
         },
         status_code: 200
       }} ->
        {:ok, Spandex.Serializer.serialize(results), count}

      error_result ->
        error_result
    end
  end

  @spec delete_index(%Spandex.Query{}) :: {:ok | :error, %HTTPoison.Response{}}
  def delete_index(query_map) do
    fn language ->
      Elastix.Index.delete(endpoint(), index_name(%{query_map | language: language}))
    end
    |> translated_index_action()
  end

  @spec delete(%Spandex.Query{}) :: {:ok | :error, %HTTPoison.Response{}}
  def delete(query_map) do
    fn language ->
      Elastix.Document.delete(
        endpoint(),
        index_name(%{query_map | language: language}),
        "_doc",
        query_map.ecto_object.id
      )

      refresh_index(query_map)
    end
    |> translated_index_action()
  end

  @spec create_index(%Spandex.Query{}) :: {:ok | :error, %HTTPoison.Response{}}
  def create_index(query_map) do
    fn language ->
      Elastix.Index.create(endpoint(), index_name(query_map), query_map.index.module.settings())

      Elastix.NewMapping.put(
        endpoint(),
        index_name(%{query_map | language: language}),
        "_doc",
        query_map.index.mapping
      )
    end
    |> translated_index_action()
  end

  @spec refresh_index(%Spandex.Query{}) :: {:ok | :error, %HTTPoison.Response{}}
  def refresh_index(query_map) do
    fn language ->
      Elastix.Index.refresh(endpoint(), index_name(%{query_map | language: language}))
    end
    |> translated_index_action()
  end

  @spec update_index(%Spandex.Query{}) :: {:ok | :error, %HTTPoison.Response{}}
  def update_index(query_map) do
    fn language ->
      Elastix.Bulk.post(
        endpoint(),
        query_map.index.module.generator(%{query_map | language: language}),
        index: index_name(query_map),
        type: "_doc"
      )

      refresh_index(query_map)
    end
    |> translated_index_action()
  end

  @spec update(%Spandex.Query{}) :: {:ok | :error, %HTTPoison.Response{}}
  def update(%Spandex.Query{ecto_object: ecto_object} = query_map) do
    fn language ->
      Elastix.Bulk.post(
        endpoint(),
        query_map.index.module.updater(ecto_object, %{query_map | language: language}),
        index: index_name(query_map),
        type: "_doc"
      )

      refresh_index(query_map)
    end
    |> translated_index_action()
  end

  defp endpoint() do
    case Application.get_env(:spandex, :endpoint) do
      nil ->
        :error

      endpoint ->
        endpoint
    end
  end

  defp index_name(%SearchService.Query{language: language, index: index})
       when language in ["", "en"] do
    index.type
    |> Macro.underscore()
    |> Inflex.pluralize()
    |> index_suffix(Mix.env())
  end

  defp index_name(query_struct), do: "#{query_struct.language}_#{index_name(query_struct)}"

  defp index_suffix(name, :test), do: name <> "_test"
  defp index_suffix(name, _), do: name

  defp translated_index_action(function) do
    languages = Application.get_env(:spandex, :languages) || ["en"]

    Enum.map(languages, fn language ->
      function.(language)
    end)
  end
end
