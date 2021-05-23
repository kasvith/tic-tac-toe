defmodule TicTacToeWeb.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)
  plug(Plug.Logger)

  get "/" do
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
