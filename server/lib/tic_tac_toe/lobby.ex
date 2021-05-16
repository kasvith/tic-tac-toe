defmodule TicTacToe.Lobby do
  use GenServer
  import Utils.String

  def start_link(_) do
    IO.puts("Lobby starting...")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def create_session(player_id) do
    GenServer.call(__MODULE__, {:create_session, player_id})
  end

  def join_session(session_id, player_id) do
    GenServer.call(__MODULE__, {:join_session, session_id, player_id})
  end

  @impl GenServer
  def init(_arg) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:create_session, player_id}, _from, store) do
    {:ok, id} = generate_game_session_id(store)

    TicTacToe.SessionSupervisor.get_process(id)
    TicTacToe.Session.join_game(id, player_id)

    {
      :reply,
      id,
      store
    }
  end

  @impl GenServer
  def handle_call({:join_session, session_id, player_id}, _from, store) do
    #  logic for joining a game
    {
      :reply,
      "reply",
      store
    }
  end

  defp generate_game_session_id(store) do
    id = Nanoid.generate(10)

    case Map.has_key?(store, id) do
      false -> {:ok, id}
      true -> generate_game_session_id(store)
    end
  end

  # @impl GenServer
  # def handle_call({:join_session, session_id, player_id}, _from, store) do
  # end

  defp get_game(store, session_id) do
    case Map.get(store, session_id) do
      session -> session
      nil -> nil
    end
  end
end
