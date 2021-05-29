defmodule TicTacToeWeb.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: TicTacToeWeb.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      )
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp dispatch do
    [
      {
        :_,
        [
          {"/ws/[...]", TicTacToeWeb.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {TicTacToeWeb.Router, []}}
        ]
      }
    ]
  end
end
