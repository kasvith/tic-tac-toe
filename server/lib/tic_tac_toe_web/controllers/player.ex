defmodule TicTacToeWeb.PlayerController do
  alias TicTacToe.PlayerSupervisor

  use Plug.Router
  import Utils.Plug

  plug(:match)
  plug(:dispatch)

  post "/register" do
    {status, resp} =
      case PlayerSupervisor.create_player(Nanoid.generate()) do
        {:ok, player_id} -> {201, %{"id" => player_id}}
        {:error, _} -> {500, %{"message" => "error creating player"}}
      end

    conn |> json_resp(status, resp)
  end

  post "/create/session" do
    conn
  end

  match _ do
    conn |> json_resp(404, %{error: "Not Found"})
  end
end
