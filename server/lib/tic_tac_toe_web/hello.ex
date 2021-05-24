defmodule TicTacToeWeb.Hello do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/secret" do
    IO.puts("get called")
    send_resp(conn, 200, "{backdoor: 'reindeer flotilla'}")
  end

  match _ do
    send_resp(conn, 404, "No authorized route")
  end
end
