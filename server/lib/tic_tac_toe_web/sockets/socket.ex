defmodule TicTacToeWeb.SocketHandler do
  import Utils.Json
  alias TicTacToeWeb.SocketRouter
  alias TicTacToe.PubSub

  @behaviour :cowboy_websocket
  require Logger

  defstruct query: %{}, player_id: nil

  @impl true
  def init(request, _state) do
    query = URI.decode_query(request.qs)
    player_id = Map.get(query, "player_id", nil)
    state = %TicTacToeWeb.SocketHandler{query: query, player_id: player_id}

    {:cowboy_websocket, request, state}
  end

  @impl true
  def websocket_init(%TicTacToeWeb.SocketHandler{player_id: player_id} = state) do
    if player_id != nil do
      PubSub.subscribe(player_id)
    end

    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, json}, state) do
    case json_decode(json) do
      {:ok, payload} ->
        handle_payload(payload, state)

      {:error, _err} ->
        {:reply, {:text, json_encode!(wrap_error("error parsing json"))}, state}
    end
  end

  @impl true
  def websocket_info(info, state) do
    handle_message(info, state)
  end

  def handle_payload(payload, state) do
    case SocketRouter.handle_payload(payload, state) do
      {:reply, reply, state} -> {:reply, {:text, json_encode!(reply)}, state}
      {:ok, state} -> {:ok, state}
    end
  end

  def handle_message(info, state) do
    case SocketRouter.handle_message(info, state) do
      {:reply, reply, state} -> {:reply, {:text, json_encode!(reply)}, state}
      {:ok, state} -> {:ok, state}
    end
  end
end
