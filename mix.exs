defmodule ExAliyun.OpenSearch.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_aliyun_opensearch,
      version: "0.1.0",
      elixir: "~> 1.10",
      config_path: "config/config.exs",
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
      {:tesla, "~> 1.3"},
      {:hackney, "1.15.2"},
      {:jason, "~> 1.2"}
    ]
  end
end
