defmodule TicTacToe.Player do
  use GenServer
  require Logger

  alias TicTacToe.Lobby
  alias TicTacToe.SessionSupervisor
  alias TicTacToe.Session

  @derive Jason.Encoder
  defstruct player_id: nil,
            current_game_session_id: nil,
            score: 0,
            playing: false,
            sign: nil

  def child_spec(player_id) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [player_id]},
      restart: :temporary
    }
  end

  def start_link([], player_id) do
    start_link(player_id)
  end

  def start_link(player_id) do
    IO.puts("Creating player #{inspect(player_id)}")
    GenServer.start_link(__MODULE__, player_id, name: via_tuple(player_id))
  end

  def create_game_session(player_id) do
    GenServer.call(via_tuple(player_id), :create_game_session)
  end

  def join_game_session(player_id, session_id) do
    GenServer.call(via_tuple(player_id), {:join_game_session, session_id})
  end

  def view_session(player_id, session_id) do
    GenServer.call(via_tuple(player_id), {:view_session, session_id})
  end

  def leave_game_session(player_id, session_id) do
    GenServer.call(via_tuple(player_id), {:leave_game_session, session_id})
  end

  def make_move(player_id, position) do
    GenServer.call(via_tuple(player_id), {:move, position})
  end

  defp via_tuple(player_id) do
    {:via, Registry, {TicTacToe.PlayerRegistry, player_id}}
  end

  def whereis(player_id) do
    case Registry.lookup(TicTacToe.PlayerRegistry, player_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def alive(player_id) do
    case Registry.lookup(TicTacToe.PlayerRegistry, player_id) do
      [{_pid, _}] -> :ok
      [] -> {:error, "player session not started"}
    end
  end

  @impl GenServer
  def init(player_id) do
    {:ok, %TicTacToe.Player{player_id: player_id}}
  end

  @impl GenServer
  def handle_call(:create_game_session, _from, %TicTacToe.Player{} = player) do
    session_id = Lobby.generate_game_session_id()

    reply =
      case SessionSupervisor.start_session(session_id) do
        {:ok, _} ->
          {:ok, session_id}

        {:error, reason} ->
          {:error, reason}
      end

    {:reply, reply, player}
  end

  @impl GenServer
  def handle_call(
        {:join_game_session, session_id},
        _from,
        %TicTacToe.Player{player_id: player_id} = player
      ) do
    {reply, state} =
      case Session.join_game(session_id, player_id) do
        {:ok, sign} ->
          {{:ok, sign},
           %TicTacToe.Player{player | current_game_session_id: session_id, playing: true}}

        {:error, reason} ->
          {{:error, reason}, player}
      end

    {:reply, reply, state}
  end

  def handle_call(
        {:leave_game_session, session_id},
        _from,
        %TicTacToe.Player{player_id: player_id} = player
      ) do
    Session.leave_game(session_id, player_id)
    {:reply, :ok, player}
  end

  def handle_call(
        {:move, pos},
        _from,
        %TicTacToe.Player{current_game_session_id: session_id, player_id: player_id} = player
      ) do
    with :ok <- Session.alive(session_id),
         {:ok, game} <- Session.move(session_id, player_id, pos) do
    end
  end

  @impl GenServer
  def handle_info(:timeout, %TicTacToe.Player{player_id: player_id} = player) do
    Logger.info("Player #{player_id} timeout")
    {:stop, :normal, player}
  end
end
