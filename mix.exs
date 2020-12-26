defmodule SimpleSearchEngine.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_search_engine,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end
  
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :poison],
      mod: {SimpleSearchEngine.Application, []}
    ]
  end

  defp deps do
    [
      {:distillery, "~> 2.1.1"},
      {:plug_cowboy, "~> 2.4.1"},  
      {:poison, "~> 4.0.1"},
      {:elastix, ">= 0.0.0"},
      {:exsync, "~> 0.2", only: :dev}       
    ]
  end
end
