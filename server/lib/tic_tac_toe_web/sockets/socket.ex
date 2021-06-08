defmodule TicTacToeWeb.SocketHandler do
  alias TicTacToeWeb.SocketRouter

  @behaviour :cowboy_websocket
  require Logger

  defstruct query: %{}

  @impl true
  def init(request, _state) do
    state = %TicTacToeWeb.SocketHandler{query: URI.decode_query(request.qs)}

    {:cowboy_websocket, request, state}
  end

  @impl true
  def websocket_init(%TicTacToeWeb.SocketHandler{} = state) do
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, json}, state) do
    {reply, state} =
      case Jason.decode(json) do
        {:ok, payload} -> handle_payload(state, payload)
        {:error, _err} -> {Jason.encode!(%{"error" => "error parsing json"}), state}
      end

    {:reply, {:text, reply}, state}
  end

  def handle_payload(payload) do
    Jason.encode!(SocketRouter.handle_payload(payload))
  end

  @impl true
  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
