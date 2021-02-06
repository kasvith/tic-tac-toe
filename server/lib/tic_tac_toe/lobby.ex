defmodule TicTacToe.Lobby do
  use GenServer
  import Utils.String

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def create_session(name) do
    GenServer.call(__MODULE__, {:create_session, name})
  end

  def join_session(session_id, player_id) do
    GenServer.call(__MODULE__, {:join_session, session_id, player_id})
  end

  @impl GenServer
  def init(_arg) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:create_session, name}, _from, store) do
    # id = create_game_session_id(store, name)
  end

  defp create_session(store, name) do
    if empty?(name) do
      generate_game_session_id(store)
    else
    end
  end

  defp generate_game_session_id(store) do
    id = Nanoid.generate(10)

    case Map.has_key?(store, id) do
      false -> id
      true -> generate_game_session_id(store)
    end
  end
end
