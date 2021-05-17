defmodule TicTacToe.Application do
  require Logger
  use Application

  @impl Application
  def start(_type, _args) do
    Logger.info("Application starting...")

    TicTacToe.Supervisor.start_link()
  end
end
