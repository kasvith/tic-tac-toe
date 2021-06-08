defmodule TicTacToeWeb.SocketRouter do
  def handle_payload(%{"type" => "create:session"} = _payload, state) do
    {%{"data" => %{"session_id" => "session_id"}}, state}
  end

  def handle_payload(%{"type" => "join:session"} = _payload, state) do
    {%{"reply" => "poong"}, state}
  end

  def handle_payload(%{} = _payload, state) do
    {%{"reply" => "hi"}, state}
  end
end
