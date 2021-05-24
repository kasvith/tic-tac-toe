defmodule TicTacToeWeb.Player do
  use Plug.Router
  import Plug.Conn

  plug(:match)
  plug(:dispatch)

  get "/register" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{"hello" => "there"}))
  end

  match _ do
    send_resp(conn, 404, "No authorized route")
  end
end
