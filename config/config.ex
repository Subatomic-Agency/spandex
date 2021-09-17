use Mix.Config

config :elastix,
  endpoint: Application.get_env(:spandex, :endpoint),
  json_codec: Application.get_env(:spandex, :json_codec)
