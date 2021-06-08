defmodule TicTacToeWeb.SocketRouter do
  def handle_payload(%{"type" => "create:session"} = _payload, state) do
    TicTacToe.PubSub.subscribe("hello")
    {%{"data" => %{"session_id" => "session_id"}}, state}
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
