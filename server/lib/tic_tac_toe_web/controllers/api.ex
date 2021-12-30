defmodule TicTacToeWeb.ApiController do
  import Utils.Plug
  import Plug.Conn

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/player", to: TicTacToeWeb.PlayerController)
  forward("/session", to: TicTacToeWeb.SessionController)

  match _ do
    conn |> json_resp(404, %{error: "Not Found"})
  end
end
