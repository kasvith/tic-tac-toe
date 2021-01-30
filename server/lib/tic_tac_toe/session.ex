defmodule TicTacToe.Session do
  use GenServer

  # client
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  @spec move(atom | pid | {atom, any} | {:via, atom, any}, String.t(), integer()) :: any
  def move(session_pid, player, position) do
    GenServer.call(session_pid, {:move, player, position})
  end

  @spec get_status(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_status(session_pid) do
    GenServer.call(session_pid, :get_status)
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
  def handle_call(:get_status, _from, game) do
    {
      :reply,
      {
        :winner,
        TicTacToe.Game.get_winner(game.board),
        :board_full,
        TicTacToe.Game.board_full?(game.board),
        :player,
        game.current_player
      },
      game
    }
  end
end
