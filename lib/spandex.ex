defmodule Spandex do
  defp adapter(), do: Application.get_env(:spandex, :adapter)

  def run_query(%{action: action} = query_map) do
    case apply(adapter(), action, [query_map]) do
      [
        ok: %HTTPoison.Response{
          status_code: status_code,
          body: %{
            "error" => %{
              "index" => index,
              "reason" => reason
            }
          }
        }
      ]
      when status_code != 200 ->
        {:error, index, reason}

      results ->
        results
    end
  end
end
