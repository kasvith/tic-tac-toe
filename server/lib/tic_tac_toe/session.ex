defmodule TicTacToe.Session do
  require Logger
  use GenServer, restart: :temporary

  # 10 mins
  @timeout 600_000

  # client
  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id)
  end

  @spec move(atom | pid | {atom, any} | {:via, atom, any}, String.t(), integer()) :: any
  def move(session_pid, player, position) do
    GenServer.call(session_pid, {:move, player, position}, @timeout)
  end

  @spec get_status(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_status(session_pid) do
    GenServer.call(session_pid, :get_status, @timeout)
  end

  @spec get_game(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_game(session_pid) do
    GenServer.call(session_pid, :get_game)
  end

  # server
  @impl GenServer
  def init(session_id) do
    {:ok, {session_id, TicTacToe.Game.new()}, @timeout}
  end

  @impl GenServer
  def handle_call({:move, player, position}, _from, {session_id, game}) do
    case TicTacToe.Game.move(game, player, position) do
      {:ok, new_game} ->
        {
          :reply,
          :ok,
          {session_id, new_game},
          @timeout
        }

      {:error, reason} ->
        {
          :reply,
          {:error, reason},
          {session_id, game},
          @timeout
        }
    end
  end

  @impl GenServer
  def handle_call(:get_status, _from, {session_id, game}) do
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
      {session_id, game},
      @timeout
    }
  end

  @impl GenServer
  def handle_call(:get_game, _from, {session_id, game}) do
    {
      :reply,
      game,
      {session_id, game},
      @timeout
    }
  end

  @impl GenServer
  def handle_info(:timeout, {session_id, game}) do
    Logger.info("Ending game session #{session_id} due to inactivity")
    {:stop, :normal, {session_id, game}}
  end
end
