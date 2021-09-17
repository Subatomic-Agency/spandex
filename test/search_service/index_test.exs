defmodule Spandex.IndexTest do
  use ExUnit.Case

  describe "reference/0" do
    test "it returns a reference to an index the Spandex can act upon" do
      assert Spandex.Index.Session.reference() ==
               %Spandex.Index{
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
               }
    end
  end
end
