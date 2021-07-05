defmodule TicTacToeWeb.SocketRouter do
  alias TicTacToe.Player
  alias TicTacToe.Session
  alias TicTacToe.PubSub
  alias TicTacToeWeb.SocketHandler
  import Utils.Json

  def handle_payload(
        %{"type" => "join:session", "data" => %{"session_id" => session_id}} = _payload,
        %SocketHandler{player_id: player_id} = state
      ) do
    reply =
      with :ok <- Player.alive(player_id),
           :ok <- Session.alive(session_id),
           {:ok, sign} <- Player.join_game_session(player_id, session_id) do
        PubSub.subscribe(session_id)
        wrap_data(%{session: %{sign: sign}})
      else
        {:error, reason} -> wrap_error(reason)
        _ -> wrap_error("unknown error")
      end

    {:reply, reply, state}
  end

  def handle_payload(%{"event" => "heartbeat"} = payload, state) do
    {:reply, payload, state}
  end

  def handle_payload(%{} = _payload, state) do
    {:ok, state}
  end

  def handle_message({:broadcast, {:session_timeout, session_id}} = _info, state) do
    {:reply, wrap_data(%{event: "session_timeout", session_id: session_id}), state}
  end

  def handle_message(_any, state) do
    {:ok, state}
  end
end
