defmodule TicTacToeWeb.PlayerController do
  import Utils.Plug
  import Utils.Json
  import Plug.Conn

  alias TicTacToe.PlayerSupervisor
  alias TicTacToe.Player
  alias TicTacToe.Session

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/register" do
    {status, resp} =
      case PlayerSupervisor.create_player(Nanoid.generate()) do
        {:ok, player_id} -> {201, %{"id" => player_id}}
        {:error, _} -> {500, %{"message" => "error creating player"}}
      end

    conn |> json_resp(status, resp)
  end

  post "/create/session" do
    %{"playerId" => player_id} = conn.body_params
    IO.puts(player_id)

    # reply =
    #   with :ok <- Player.alive(player_id),
    #        {:ok, session_id} <- Player.create_game_session(player_id),
    #        {:ok, sign} <- Session.join_game(session_id, player_id) do
    #     wrap_data(%{session: %{id: session_id, sign: sign}})
    #   else
    #     {:error, reason} -> wrap_error(reason)
    #     _ -> wrap_error("unknown error")
    #   end

    conn |>
  end

  match _ do
    conn |> json_resp(404, %{error: "Not Found"})
  end
end
