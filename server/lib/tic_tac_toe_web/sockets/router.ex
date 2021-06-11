defmodule TicTacToeWeb.SocketRouter do
  alias TicTacToe.Player
  alias TicTacToe.Session
  import Utils.Json

  def handle_payload(
        %{"type" => "join:session", "data" => %{"session_id" => session_id}} = _payload,
        %TicTacToeWeb.SocketHandler{player_id: player_id} = state
      ) do
    reply =
      with :ok <- Player.alive(player_id),
           :ok <- Session.alive(session_id),
           {:ok, sign} <- Session.join_game(session_id, player_id) do
        wrap_data(%{session: %{sign: sign}})
      else
        {:error, reason} -> wrap_error(reason)
        _ -> wrap_error("unknown error")
      end

    {:reply, reply, state}
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
