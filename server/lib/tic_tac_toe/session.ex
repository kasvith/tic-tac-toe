defmodule TicTacToe.Session do
  require Logger
  use GenServer, restart: :temporary

  defstruct [:session_id, game: TicTacToe.Game.new(), players: %{}]

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

  def join_game(session_pid, player_id) do
    GenServer.call(session_pid, {:join_game, player_id})
  end

  # server
  @impl GenServer
  def init(session_id) do
    {:ok, %TicTacToe.Session{session_id: session_id}, @timeout}
  end

  @impl GenServer
  def handle_call({:move, player, position}, _from, %{game: game} = state) do
    case TicTacToe.Game.move(game, player, position) do
      {:ok, new_game} ->
        {
          :reply,
          :ok,
          %TicTacToe.Session{state | game: new_game},
          @timeout
        }

      {:error, reason} ->
        {
          :reply,
          {:error, reason},
          state,
          @timeout
        }
    end
  end

  @impl GenServer
  def handle_call(:get_status, _from, %{game: game} = state) do
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
      state,
      @timeout
    }
  end

  @impl GenServer
  def handle_call(:get_game, _from, %{game: game} = state) do
    {
      :reply,
      game,
      state,
      @timeout
    }
  end

  @impl GenServer
  def handle_call(:join_game, _from, %{game: game} = state) do
    {
      :reply,
      game,
      state,
      @timeout
    }
  end

  @impl GenServer
  def handle_info(:timeout, %{session_id: session_id} = state) do
    Logger.info("Ending game session #{session_id} due to inactivity")
    {:stop, :normal, state}
  end
end
