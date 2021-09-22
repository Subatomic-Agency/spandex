defmodule Spandex.Test.Helpers do
  def reindex_all() do
    [:delete_index, :create_index, :update_index]
    |> Enum.map(&take_action(&1))
  end

  def tear_down() do
    take_action(:delete_index)
  end

  defp take_action(action) do
    for {module, _} <- :code.all_loaded(),
        Spandex.Behaviour.Index in (module.module_info(:attributes)
                                    |> Keyword.get_values(:behaviour)
                                    |> List.flatten()) do
      module
      |> Spandex.Query.compile(%{action: action})
      |> Spandex.run_query()
    end
  end
end
