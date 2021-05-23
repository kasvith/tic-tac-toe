defmodule TicTacToeWeb.Hello do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{"status" => "ok"}))
  end
end
