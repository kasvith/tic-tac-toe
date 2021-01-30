defmodule TicTacToe.Session do
  use GenServer

  # client
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def move(session_pid, player, position) do
    GenServer.call(session_pid, {:move, player, position})
  end

  def get_game(session_pid) do
    GenServer.call(session_pid, :get)
  end

  # server
  @impl GenServer
  def init(_) do
    {:ok, TicTacToe.Game.new()}
  end

  @impl GenServer
  def handle_call({:move, player, position}, _from, game) do
    case TicTacToe.Game.move(game, player, position) do
      {:ok, new_game} ->
        {
          :reply,
          :ok,
          new_game
        }

      {:error, reason} ->
        {
          :reply,
          {:error, reason},
          game
        }
    end
  end

  @impl GenServer
  def handle_call(:get, _from, game) do
    {:reply, game, game}
  end
end
