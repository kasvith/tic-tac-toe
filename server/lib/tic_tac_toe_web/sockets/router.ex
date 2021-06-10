defmodule TicTacToeWeb.SocketRouter do
  alias TicTacToe.Player
  alias TicTacToe.Session
  import Utils.Json

  def handle_payload(
        %{"type" => "create:session"} = _payload,
        %TicTacToeWeb.SocketHandler{player_id: player_id} = state
      ) do
    reply =
      with :ok <- Player.alive(player_id),
           {:ok, session_id} <- Player.create_game_session(player_id),
           {:ok, sign} <- Session.join_game(session_id, player_id) do
        wrap_data(%{session: %{id: session_id, sign: sign}})
      else
        {:error, reason} -> wrap_error(reason)
        _ -> wrap_error("unknown error")
      end

    {:reply, reply, state}
  end

  def handle_payload(%{"type" => "join:session"} = _payload, state) do
    {:reply, %{reply: "poong"}, state}
  end

  def handle_payload(%{} = _payload, state) do
    {:reply, %{reply: "hi"}, state}
  end

  def handle_message({:broadcast, :world} = _info, state) do
    {:reply, %{reply: "message"}, state}
  end

  def handle_message(_any, state) do
    {:ok, state}
  end
end
