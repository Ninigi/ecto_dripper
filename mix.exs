defmodule EctoDripper.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_dripper,
      version: "1.0.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    """
    A simple way to create Ecto Queries.
    Clean up and declutter your query modules by only writing out the necessary code - or no code at all.
    """
  end

  defp package() do
    [
      name: "ecto_dripper",
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", ".formatter.exs"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ninigi/ecto_dripper"},
      maintainers: ["Fabian Zitter"]
    ]
  end
end
