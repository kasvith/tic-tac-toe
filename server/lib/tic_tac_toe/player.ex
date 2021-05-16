defmodule TicTacToe.Player do
  use GenServer

  defstruct player_id: nil,
            current_game_session: nil,
            score: 0,
            playing: false

  @timeout 15 * 60 * 1000

  def start_link(player_id) do
    GenServer.call(__MODULE__, player_id)
  end

  def create_game_session(pid) do
    GenServer.call(pid, :create_game_session, @timeout)
  end

  def join_game_session(pid, session_id) do
    GenServer.call(pid, {:join_game_session, session_id}, @timeout)
  end

  def view_session(pid, session_id) do
    GenServer.call(pid, {:view_session, session_id}, @timeout)
  end

  def leave_game_session(pid, session_id) do
    GenServer.call(pid, {:leave_game_session, session_id}, @timeout)
  end

  @impl GenServer
  def init(player_id) do
    {:ok, %TicTacToe.Player{player_id: player_id}, @timeout}
  end

  @impl GenServer
  def handle_call(:create_game_session, _from, %TicTacToe.Player{} = player) do
  end
end
