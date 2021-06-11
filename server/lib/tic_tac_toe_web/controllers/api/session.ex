defmodule TicTacToeWeb.SessionController do
  import Utils.Plug
  import Utils.Json
  import Plug.Conn

  alias TicTacToe.Session

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/:session_id" do
    {status, reply} =
      with :ok <- Session.alive(session_id),
           session <- Session.get_session(session_id) do
        {200, %{session: session}}
      else
        {:error, reason} -> {400, wrap_error(reason)}
        _ -> {500, wrap_error("unknown error")}
      end

    conn |> json_resp(status, reply)
  end

  match _ do
    conn |> json_resp(404, %{error: "Not Found"})
  end
end
