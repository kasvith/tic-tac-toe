defmodule TicTacToe.Session do
  require Logger
  use GenServer, restart: :transient

  @type t :: %__MODULE__{
          session_id: String.t() | nil,
          game: TicTacToe.Game.t() | nil,
          player_x: String.t() | nil,
          player_o: String.t() | nil,
          stats: %{optional(String.t()) => integer()}
        }

  defstruct session_id: nil,
            game: TicTacToe.Game.new(),
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
    GenServer.call(session_pid, {:get_game})
  end

  @spec join_game(pid(), String.t()) :: any
  def join_game(session_pid, player_id) do
    GenServer.call(session_pid, {:join_game, player_id})
  end

  @spec leave_game(pid(), String.t()) :: any
  def leave_game(session_pid, player_id) do
    GenServer.call(session_pid, {:leave_game, player_id})
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
        %TicTacToe.Session{game: game} = state
      ) do
    player = get_player_sign(state, player_id)

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

  @impl GenServer
  def handle_call({:get_game}, _from, %TicTacToe.Session{game: game} = state) do
    {
      :reply,
      game,
      state,
      @timeout_milliseconds
    }
  end

  @impl GenServer
  def handle_call(
        {:join_game, player_id},
        _from,
        %TicTacToe.Session{player_x: player_x, player_o: player_o} = state
      ) do
    {reply, state} =
      cond do
        player_x == nil ->
          {{:ok, :x}, %TicTacToe.Session{state | player_x: player_id}}

        player_o == nil ->
          {{:ok, :o}, %TicTacToe.Session{state | player_o: player_id}}

        player_o == player_id || player_x == player_id ->
          {{:ok, get_player_sign(state, player_id)}, state}

        true ->
          {{:error, "room full"}, state}
      end

    {
      :reply,
      reply,
      state,
      @timeout_milliseconds
    }
  end

  @impl GenServer
  def handle_call(
        {:leave_game, player_id},
        _from,
        %TicTacToe.Session{player_x: player_x, player_o: player_o} = state
      ) do
    new_state =
      case player_id do
        ^player_x -> %TicTacToe.Session{state | player_x: nil}
        ^player_o -> %TicTacToe.Session{state | player_o: nil}
        _ -> state
      end

    {
      :reply,
      {:ok},
      new_state,
      @timeout_milliseconds
    }
  end

  @impl GenServer
  def handle_info(:timeout, %TicTacToe.Session{session_id: session_id} = state) do
    Logger.info("Ending game session #{session_id} due to inactivity")
    {:stop, :normal, state}
  end

  defp get_player_sign(
         %TicTacToe.Session{player_x: player_x, player_o: player_o},
         player_id
       ) do
    case player_id do
      ^player_x -> :x
      ^player_o -> :o
    end
  end
end
