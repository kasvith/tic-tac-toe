defmodule TicTacToeWeb.ApiController do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/player", to: TicTacToeWeb.PlayerController)
  forward("/session", to: TicTacToeWeb.SessionController)
end
