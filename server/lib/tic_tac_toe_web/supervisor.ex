defmodule TicTacToeWeb.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: TicTacToeWeb.Router, options: [port: 8080]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
