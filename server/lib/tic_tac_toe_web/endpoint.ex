defmodule TicTacToeWeb.Endpoint do
  use Plug.Router
  import Utils.Json

  import Plug.Conn

  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  use Plug.ErrorHandler

  forward("/player", to: TicTacToeWeb.PlayerController)

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, json_encode!(%{message: "Not Found"}))
  end
end
