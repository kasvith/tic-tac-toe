defmodule TicTacToe.PubSub do
  @registry TicTacToe.PubSubRegistry

  def broadcast(topic, message) do
    Registry.dispatch(@registry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, message})
    end)
  end

  def broadcast_from(sender_pid, topic, message) do
    Registry.dispatch(
      @registry,
      topic,
      fn entries ->
        for {pid, _} <- entries, pid != sender_pid, do: send(pid, {:broadcast, message})
      end
    )
  end

  def subscribe(topic) do
    Registry.register(@registry, topic, [])
  end
end
