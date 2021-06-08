defmodule TicTacToeWeb.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    port = 4000

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: TicTacToeWeb.Router,
        options: [
          dispatch: dispatch(),
          port: port
        ]
      )
    ]

    Logger.info("Starting server at port #{port}")

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
