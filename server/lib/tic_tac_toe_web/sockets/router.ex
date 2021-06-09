defmodule TicTacToeWeb.SocketRouter do
  alias TicTacToe.Player

  def handle_payload(
        %{"type" => "create:session"} = _payload,
        %TicTacToeWeb.SocketHandler{player_id: player_id} = state
      ) do
    reply =
      case Player.create_game_session(player_id) do
        {:ok, session_id} -> %{"data" => %{"sessionId" => session_id}}
        {:error, _err} -> %{"error" => "error creating game session"}
      end

    {reply, state}
  end

  def handle_payload(%{"type" => "join:session"} = _payload, state) do
    {%{"reply" => "poong"}, state}
  end

  def handle_payload(%{} = _payload, state) do
    {%{"reply" => "hi"}, state}
  end

  def handle_message({:broadcast, :world} = _info, state) do
    {%{"reply" => "message"}, state}
  end

  def handle_message(_any, state) do
    {%{"reply" => "hmm"}, state}
  end
end
