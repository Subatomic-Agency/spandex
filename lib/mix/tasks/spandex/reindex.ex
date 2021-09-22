defmodule Mix.Tasks.Spandex.Reindex do
  @moduledoc """
  Does the spandex dance. For every index in the app this deletes
  the old index, creates a new one and populates it
  """
  @shortdoc "Reindex all indices"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")

    actions = [:delete_index, :create_index, :update_index]

    for {module, _} <- :code.all_loaded(),
        Spandex.Behaviour.Index in (module.module_info(:attributes)
                                    |> Keyword.get_values(:behaviour)
                                    |> List.flatten()),
        action <- actions do
      module
      |> Spandex.Query.compile(%{action: action})
      |> Spandex.run_query()
    end
  end
end
