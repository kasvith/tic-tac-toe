defmodule TicTacToe.Application do
  require Logger
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      TicTacToe.Supervisor,
      TicTacToeWeb.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Main.Supervisor]

    Logger.info("Application starting...")

    Supervisor.start_link(children, opts)
  end
end
