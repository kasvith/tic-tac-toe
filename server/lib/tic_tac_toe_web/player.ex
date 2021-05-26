defmodule TicTacToeWeb.Player do
  alias TicTacToe.PlayerSupervisor

  use Plug.Router
  import Plug.Conn

  plug(:match)
  plug(:dispatch)

  post "/register" do
    {status, resp} =
      case PlayerSupervisor.create_player(Nanoid.generate()) do
        {:ok, player_id} -> {201, %{"id" => player_id}}
        {:error, _} -> {500, %{"message" => "error creating player"}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(resp))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
