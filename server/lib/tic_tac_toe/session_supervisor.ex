defmodule TicTacToe.SessionSupervisor do
  use DynamicSupervisor

  def start_link(init_args) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def start_session(session_id) do
    spec = {TicTacToe.Session, session_id}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, _pid} -> {:ok, session_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end

  @impl true
  def init(init_args) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [init_args])
  end
end
