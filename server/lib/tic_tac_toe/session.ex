defmodule TicTacToe.Session do
  require Logger
  use GenServer, restart: :transient

  @type t :: %__MODULE__{
          session_id: String.t(),
          game: TicTacToe.Game.t(),
          player_x: String.t(),
          player_o: String.t(),
          stats: %{optional(String.t()) => integer()}
        }

  defstruct session_id: nil,
            game: nil,
            player_x: nil,
            player_o: nil,
            stats: %{}

  # 10 mins
  @timeout_milliseconds 10 * 60 * 1000

  # client
  @spec start_link(String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id)
  end

  @spec move(pid(), String.t(), integer()) :: any
  def move(session_pid, player_id, position) do
    GenServer.call(session_pid, {:move, player_id, position}, @timeout_milliseconds)
  end

  @spec get_game(pid()) :: any
  def get_game(session_pid) do
    GenServer.call(session_pid, :get_game)
  end

  @spec join_game(pid, String.t()) :: any
  def join_game(session_pid, player_id) do
    GenServer.call(session_pid, {:join_game, player_id})
  end

  @spec leave_game(pid(), String.t()) :: any
  def leave_game(session_pid, player_id) do
    GenServer.cast(session_pid, {:leave_game, player_id})
  end

  # server
  @impl GenServer
  def init(session_id) do
    {:ok, %TicTacToe.Session{session_id: session_id}, @timeout_milliseconds}
  end

  @impl GenServer
  def handle_call(
        {:move, player_id, position},
        _from,
        %TicTacToe.Session{game: game, players: players} = state
      ) do
    player = Map.get(players, player_id)

    {result, state} =
      case TicTacToe.Game.move(game, player, position) do
        {:ok, updated_game} ->
          {
            :ok,
            %TicTacToe.Session{state | game: updated_game}
          }

        {:error, reason} ->
          {
            {:error, reason},
            state
          }
      end

    {:reply, result, state, @timeout_milliseconds}
  end

  defp get_player_sign(player_id) do
    case player_id do
      player ->
        nil
    end
  end

  @impl GenServer
  def handle_call(:get_game, _from, %TicTacToe.Session{game: game} = state) do
    {
      :reply,
      game,
      state,
      @timeout_milliseconds
    }
  end

  @impl GenServer
  def handle_call({:join_game, _player_id}, _from, %TicTacToe.Session{players: players} = state)
      when is_map(players) and map_size(players) == 2 do
    {
      :reply,
      {:error, "room full"},
      state,
      @timeout_milliseconds
    }
  end

  @impl GenServer
  def handle_call({:join_game, player_id}, _from, %TicTacToe.Session{players: players} = state) do
    {reply, state} =
      case registered?(players, player_id) do
        true ->
          {{:ok, Map.get(players, player_id)}, state}

        false ->
          sign = get_player_sign(players)
          new_players = Map.put(players, player_id, sign)
          {{:ok, sign}, %TicTacToe.Session{state | players: new_players}}
      end

    {
      :reply,
      reply,
      state,
      @timeout_milliseconds
    }
  end

  defp registered?(players, player_id) do
    Map.has_key?(players, player_id)
  end

  defp get_player_sign(players) do
    has_x = players |> Map.values() |> Enum.member?(:x)

    case has_x do
      true -> :o
      false -> :x
    end
  end

  @impl GenServer
  def handle_cast({:leave_game, player_id}, %TicTacToe.Session{players: players} = state) do
    {
      :noreply,
      %TicTacToe.Session{state | players: Map.delete(players, player_id)},
      @timeout_milliseconds
    }
  end

  @impl GenServer
  def handle_info(:timeout, %TicTacToe.Session{session_id: session_id} = state) do
    Logger.info("Ending game session #{session_id} due to inactivity")
    {:stop, :normal, state}
  end
end
