defmodule UtilvoShieldFilters.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/utilvo/utilvo-shield-filters"
  @homepage_url "https://utilvo.com/shield"

  def project do
    [
      app: :utilvo_shield_filters,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description:
        "Zero-dependency parser and domain suffix matcher for Adblock Plus 2.0 and uBlock Origin static network filter rules.",
      package: package(),
      deps: []
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp package do
    [
      name: "utilvo_shield_filters",
      files: ~w(lib/utilvo_shield_filters.ex mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{
        "Homepage" => @homepage_url,
        "GitHub" => @source_url
      }
    ]
  end
end
