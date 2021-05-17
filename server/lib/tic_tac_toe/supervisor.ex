defmodule TicTacToe.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: TicTacToe.SessionRegistry},
      {Registry, keys: :unique, name: TicTacToe.PlayerRegistry},
      {Registry, keys: :duplicate, name: TicTacToe.PubSub},
      TicTacToe.SessionSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
