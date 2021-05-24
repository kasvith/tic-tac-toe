defmodule TicTacToeWeb.Router do
  use Plug.Router

  plug(:match)
  plug(Plug.Logger)
  plug(:dispatch)

  use Plug.ErrorHandler

  forward("/hello", to: TicTacToeWeb.Hello)

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
