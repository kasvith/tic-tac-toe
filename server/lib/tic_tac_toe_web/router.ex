defmodule TicTacToeWeb.Router do
  use Plug.Router
  import Plug.Conn
  Plug.Conn

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  use Plug.ErrorHandler

  forward("/hello", to: TicTacToeWeb.Player)

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{"message" => "Not Found"}))
  end
end
