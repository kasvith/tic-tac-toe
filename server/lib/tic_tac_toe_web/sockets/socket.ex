defmodule TicTacToeWeb.SocketHandler do
  alias TicTacToeWeb.SocketRouter

  @behaviour :cowboy_websocket
  require Logger

  defstruct query: %{}, player_id: nil

  @impl true
  def init(request, _state) do
    query = URI.decode_query(request.qs)
    player_id = Map.get(query, "playerId", nil)
    state = %TicTacToeWeb.SocketHandler{query: query, player_id: player_id}

    {:cowboy_websocket, request, state}
  end

  @impl true
  def websocket_init(%TicTacToeWeb.SocketHandler{} = state) do
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, json}, state) do
    {reply, state} =
      case Poison.decode(json) do
        {:ok, payload} -> handle_payload(payload, state)
        {:error, _err} -> {Poison.encode!(%{"error" => "error parsing json"}), state}
      end

    {:reply, {:text, reply}, state}
  end

  @impl true
  def websocket_info(info, state) do
    {reply, state} = handle_message(info, state)
    {:reply, {:text, reply}, state}
  end

  def handle_payload(payload, state) do
    {reply, state} = SocketRouter.handle_payload(payload, state)
    {Poison.encode!(reply), state}
  end

  def handle_message(info, state) do
    {reply, state} = SocketRouter.handle_message(info, state)
    {Poison.encode!(reply), state}
  end
end
