defmodule TicTacToe.PubSub do
  def broadcast(topic, message, _current_pid \\ nil) do
    Registry.dispatch(TicTacToe.PubSubRegistry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, message})
    end)
  end

  def subscribe(topic) do
    Registry.register(TicTacToe.PubSubRegistry, topic, [])
  end
end
