defmodule TicTacToe.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    IO.puts("Application starting...")

    children = [
      {Registry, keys: :unique, name: TicTacToe.SessionRegistry},
      {TicTacToe.Lobby, []},
      {TicTacToe.SessionSupervisor, strategy: :one_for_one, name: TicTacToe.SessionSupervisor}
    ]

    opts = [strategy: :one_for_one, name: TicTacToe.MainSupervisor]
    Supervisor.start_link(children, opts)
  end
end
