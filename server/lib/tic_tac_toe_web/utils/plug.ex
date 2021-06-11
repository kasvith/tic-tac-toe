defmodule Utils.Plug do
  import Plug.Conn
  import Utils.Json

  @spec json_resp(Plug.Conn.t(), integer(), any) :: Plug.Conn.t()
  def json_resp(conn, status, resp) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, json_encode!(resp))
  end
end
