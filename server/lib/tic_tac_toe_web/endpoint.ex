defmodule TicTacToeWeb.Endpoint do
  use Plug.Router
  import Plug.Conn

  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  use Plug.ErrorHandler

  forward("/player", to: TicTacToeWeb.PlayerController)

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Poison.encode!(%{"message" => "Not Found"}))
  end
end
