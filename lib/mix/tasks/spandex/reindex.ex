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

    Spandex.reindex_all()
  end
end
