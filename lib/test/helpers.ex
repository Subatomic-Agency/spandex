defmodule Spandex.Test.Helpers do
  def reindex_all() do
    [:delete_index, :create_index, :update_index]
    |> Enum.map(&take_action(&1))
  end

  def tear_down() do
    take_action(:delete_index)
  end

  defp take_action(action) do
    Spandex.queries()
    |> Enum.each(fn query ->
      query
      |> Spandex.Query.compile(%{action: action})
      |> Spandex.run_query()
    end)
  end
end
