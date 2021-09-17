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
                   module: Spandex.Index.Session,
                   type: "session"
                 },
                 language: "en",
                 query: %Spandex.Query.Session{query: nil}
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
                   module: Spandex.Index.Session,
                   type: "session"
                 },
                 language: "en",
                 query: %Spandex.Query.Session{query: nil}
               }
    end
  end
end
