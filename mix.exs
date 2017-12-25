defmodule Blitzy.Mixfile do
  use Mix.Project

  def project do
    [app: :blitzy,
     version: "0.0.3",
     elixir: "~> 1.1",
     escript: escript(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
   ]
  end

  def escript do
    [main_module: Blitzy.CLI]
  end

  def application do
    [mod: {Blitzy, []},
     applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.10.0"},
      {:timex,     "~> 3.1"},
      {:excoveralls, "~> 0.5", only: :test},
      {:mock, "~> 0.2.0", only: :test},
	  {:poison, "~> 3.0"}
    ]
  end
end
