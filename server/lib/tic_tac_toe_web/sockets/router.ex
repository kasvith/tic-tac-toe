defmodule TicTacToeWeb.SocketRouter do
  def handle_payload(%{"type" => "ping"} = _payload) do
    %{"reply" => "pong"}
  end

  def handle_payload(%{"type" => "join", "data" => %{  }} = _payload) do
    %{"reply" => "poong"}
  end

  def handle_payload(%{} = _payload) do
    %{"reply" => "hi"}
  end
end
