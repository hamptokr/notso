defmodule Notso.MixProject do
  use Mix.Project

  def project do
    [
      app: :notso,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:hackney, :logger, :jason],
      env: env(),
      mod: {Notso, []}
    ]
  end

  defp env() do
    [
      api_base_url: "https://api.notion.com",
      pool_options: [
        timeout: 5_000,
        max_connections: 10
      ],
      use_connection_pool: true
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.24.2", only: :dev},
      {:excoveralls, "~> 0.14.0", only: :test},
      {:hackney, "~> 1.17"},
      {:inch_ex, "~> 2.0", only: [:dev, :test]},
      {:mox, "~> 1.0", only: :test},
      {:jason, "~> 1.2"}
    ]
  end
end
