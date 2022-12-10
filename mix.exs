defmodule Mix.Tasks.Compile.Make do
  def run(_args) do
    {result, code} = System.cmd("make", [], stderr_to_stdout: true)
    IO.binwrite(result)

    case code do
      0 -> :ok
      code -> {:error, ["Exit code: #{code}"]}
    end
  end
end

defmodule RSVG.MixProject do
  use Mix.Project

  def project do
    [
      app: :rsvg,
      version: "0.1.0",
      elixir: "~> 1.14",
      compilers: [:make] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
