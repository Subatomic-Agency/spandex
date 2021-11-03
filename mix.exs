defmodule Spandex.MixProject do
  use Mix.Project

  def project do
    [
      app: :spandex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elastix,
       github: "Subatomic-Agency/elastix",
       ref: "9afc57c9de3c3014d25b62d11e806433e72c35ba"},
      {:inflex, "~> 2.1"}
    ]
  end
end
