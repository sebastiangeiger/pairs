defmodule Pairs.Mixfile do
  use Mix.Project

  def project do
    [app: :pairs,
     version: "0.1.0",
     elixir: "~> 1.3",
     name: "Pairs",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application, do: []

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.13.0", only: :dev},
     {:earmark, "~> 1.0.1", only: :dev}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Sebastian Geiger"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/sebastiangeiger/pairs",
        "Docs" => "http://hexdocs.pm/pairs/"
      }
    ]
  end

  defp description do
    """
    Pairs is a small library that makes it easy to create pairs from two lists.
    """
  end
end
