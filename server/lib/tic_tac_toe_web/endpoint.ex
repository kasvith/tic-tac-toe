defmodule TicTacToeWeb.Endpoint do
  use Plug.Router
  import Utils.Plug

  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  use Plug.ErrorHandler

  forward("/api", to: TicTacToeWeb.ApiController)

  match _ do
    conn
    |> json_resp(404, %{error: "Not Found"})
  end
end
