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
    reply =
      case create_session(store, name) do
        {:ok, id} -> {:ok, id}
        {:error, reason} -> {:error, reason}
      end

    {
      :reply,
      reply,
      store
    }
  end

  defp create_session(store, name) do
    if empty?(name) do
      generate_game_session_id(store)
    else
      create_session_name(store, name)
    end
  end

  defp create_session_name(store, name) do
    case Map.has_key?(store, name) do
      true ->
        {:ok, name}

      false ->
        {:error, "already exists"}
    end
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
