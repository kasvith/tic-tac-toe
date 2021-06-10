defmodule TicTacToeWeb.SocketRouter do
  alias TicTacToe.Player
  alias TicTacToe.Session

  def handle_payload(
        %{"type" => "create:session"} = _payload,
        %TicTacToeWeb.SocketHandler{player_id: player_id} = state
      ) do
    reply =
      with {:player_exists, true} <- {:player_exists, Player.is_alive?(player_id)},
           {:session_created, reply} <-
             {:session_created, handle_create_session(player_id)},
           {:join_session, _reply} <- {:join_session} do
        reply
      else
        {:player_exists, _} -> %{"error" => "player session not started yet"}
        _ -> %{"error" => "unknown error"}
      end

    {:reply, reply, state}
  end

  def handle_payload(%{"type" => "join:session"} = _payload, state) do
    {:reply, %{"reply" => "poong"}, state}
  end

  def handle_payload(%{} = _payload, state) do
    {:reply, %{"reply" => "hi"}, state}
  end

  def handle_message({:broadcast, :world} = _info, state) do
    {:reply, %{"reply" => "message"}, state}
  end

  def handle_message(_any, state) do
    {:ok, state}
  end

  def handle_create_session(player_id) do
    case Player.create_game_session(player_id) do
      {:ok, session_id} -> %{"data" => %{"sessionId" => session_id}}
      {:error, _err} -> %{"error" => "error creating game session"}
    end
  end

  def join_session(session_id, player_id) do
    case Session.join_game(session_id, player_id) do
      () ->
        nil
    end
  end
end
