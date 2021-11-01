defmodule Spandex do
  defp adapter(), do: Application.get_env(:spandex, :adapter)

  def run_query(%{action: action} = query_map) do
    case apply(adapter(), action, [query_map]) do
      {
        :ok,
        %HTTPoison.Response{
          status_code: status_code,
          body: %{
            "error" => %{
              "index" => index,
              "reason" => reason
            }
          }
        }
      }
      when status_code != 200 ->
        {:error, index, reason}

      results ->
        results
    end
  end

  def reindex_all() do
    actions = [:delete_index, :create_index, :update_index]

    for query <- queries(),
        action <- actions do
      query
      |> Spandex.Query.compile(%{action: action})
      |> Spandex.run_query()
    end
  end

  def indices() do
    app_modules()
    |> Enum.filter(&(Spandex.Behaviour.Index in behaviours(&1)))
  end

  def queries() do
    app_modules()
    |> Enum.filter(&(Spandex.Behaviour.Index in behaviours(&1)))
  end

  defp app_modules() do
    namespace = Application.get_env(:spandex, :namespace)
    {:ok, modules} = :application.get_key(namespace, :modules)

    modules
  end

  defp behaviours(module) do
    module.module_info(:attributes)
    |> Keyword.get_values(:behaviour)
    |> List.flatten()
  end
end
