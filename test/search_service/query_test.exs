defmodule Spandex.Index.Session do
  use Spandex.Index

  @spec settings() :: map
  @impl true
  def settings() do
    %{
      settings: %{}
    }
  end

  @spec mapping() :: Spandex.Behaviour.Index.index_mapping()
  @impl true
  def mapping() do
    %{
      properties: %{
        id: %{type: "integer"},
        title: %{type: "text"},
        category: %{type: "text"},
        "contributor.name": %{type: "text"},
        "asset.text_content": %{type: "text"}
      }
    }
  end

  @spec generator(String.t()) :: [Spandex.Behaviour.Index.index_generator_list()]
  @impl true
  def generator(_language \\ "en"), do: []

  @spec updater(%{}) :: [Spandex.Behaviour.Index.index_generator_list()]
  @impl true
  def updater(_session, _language \\ "en"), do: []
end

defmodule Spandex.Query.Session do
  use Spandex.QueryBuilder, index: Spandex.Index.Session
  defstruct [:query, :index]
end

defmodule Spandex.QueryTest do
  use ExUnit.Case

  describe "compile/2" do
    test "it takes a blank query map and returns a Spandex.Query" do
      assert Spandex.Query.Session.new()
             |> Spandex.Query.compile() ==
               %Spandex.Query{
                 action: :search,
                 ecto_object: nil,
                 index: %Spandex.Index{
                   mapping: %{
                     properties: %{
                       category: %{type: "text"},
                       "contributor.name": %{type: "text"},
                       id: %{type: "integer"},
                       title: %{type: "text"},
                       "asset.text_content": %{type: "text"}
                     }
                   },
                   module: Spandex.Index.Session
                 },
                 language: "en",
                 query: %Spandex.Query.Session{query: nil, index: Spandex.Index.Session}
               }
    end

    test "it has parameters that can be overridden" do
      assert Spandex.Query.Session.new()
             |> Spandex.Query.compile(%{action: :create}) ==
               %Spandex.Query{
                 action: :create,
                 ecto_object: nil,
                 index: %Spandex.Index{
                   mapping: %{
                     properties: %{
                       category: %{type: "text"},
                       "contributor.name": %{type: "text"},
                       id: %{type: "integer"},
                       title: %{type: "text"},
                       "asset.text_content": %{type: "text"}
                     }
                   },
                   module: Spandex.Index.Session
                 },
                 language: "en",
                 query: %Spandex.Query.Session{query: nil, index: Spandex.Index.Session}
               }
    end
  end
end
