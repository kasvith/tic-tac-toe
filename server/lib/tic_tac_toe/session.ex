defmodule TicTacToe.Session do
  require Logger
  use GenServer, restart: :transient

  defstruct [:session_id, game: TicTacToe.Game.new(), players: %{}]

  # 10 mins
  @timeout 600_000

  # client
  @spec start_link(String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id)
  end

  @spec move(atom | pid | {atom, any} | {:via, atom, any}, String.t(), integer()) :: any
  def move(session_pid, player_id, position) do
    GenServer.call(session_pid, {:move, player_id, position}, @timeout)
  end

  @spec get_status(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_status(session_pid) do
    GenServer.call(session_pid, :get_status, @timeout)
  end

  @spec get_game(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_game(session_pid) do
    GenServer.call(session_pid, :get_game)
  end

  @spec join_game(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def join_game(session_pid, player_id) do
    GenServer.call(session_pid, {:join_game, player_id})
  end

  @spec leave_game(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def leave_game(session_pid, player_id) do
    GenServer.cast(session_pid, {:leave_game, player_id})
  end

  # server
  @impl GenServer
  def init(session_id) do
    {:ok, %TicTacToe.Session{session_id: session_id}, @timeout}
  end

  @impl GenServer
  def handle_call(
        {:move, player_id, position},
        _from,
        %TicTacToe.Session{game: game, players: players} = state
      ) do
    player = Map.get(players, player_id)

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
  def handle_call(:get_status, _from, %TicTacToe.Session{game: game} = state) do
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
  def handle_call(:get_game, _from, %TicTacToe.Session{game: game} = state) do
    {
      :reply,
      game,
      state,
      @timeout
    }
  end

  @impl GenServer
  def handle_call({:join_game, _player_id}, _from, %TicTacToe.Session{players: players} = state)
      when is_map(players) and map_size(players) >= 2 do
    {
      :reply,
      {:error, "room full"},
      state,
      @timeout
    }
  end

  @impl GenServer
  def handle_call({:join_game, player_id}, _from, %TicTacToe.Session{players: players} = state) do
    if registered?(players, player_id) do
      {
        :reply,
        {:ok, Map.get(players, player_id)},
        state,
        @timeout
      }
    else
      sign = get_player_sign(players)
      new_players = Map.put(players, player_id, sign)

      {
        :reply,
        {:ok, sign},
        %TicTacToe.Session{state | players: new_players},
        @timeout
      }
    end
  end

  defp registered?(players, player_id) do
    Map.has_key?(players, player_id)
  end

  defp get_player_sign(players) do
    has_x = players |> Map.values() |> Enum.member?("X")

    case has_x do
      true -> "O"
      false -> "X"
    end
  end

  @impl GenServer
  def handle_cast({:leave_game, player_id}, %TicTacToe.Session{players: players} = state) do
    {
      :noreply,
      %TicTacToe.Session{state | players: Map.delete(players, player_id)},
      @timeout
    }
  end

  @impl GenServer
  def handle_info(:timeout, %TicTacToe.Session{session_id: session_id} = state) do
    Logger.info("Ending game session #{session_id} due to inactivity")
    {:stop, :normal, state}
  end
end
