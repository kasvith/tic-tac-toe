defmodule TicTacToe.PubSub do
  @registry TicTacToe.PubSubRegistry

  def broadcast(topic, message, _current_pid \\ nil) do
    Registry.dispatch(@registry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, message})
    end)
  end

  def subscribe(topic) do
    Registry.register(@registry, topic, [])
  end
end
