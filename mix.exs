defmodule RSVG.MixProject do
  use Mix.Project

  def project do
    [
      app: :rsvg,
      version: "0.1.0",
      elixir: "~> 1.14",
      compilers: [:elixir_make] ++ Mix.compilers(),
      make_targets: ["all"],
      make_clean: ["clean"],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:elixir_make, "~> 0.7.1", runtime: false}
    ]
  end
end
