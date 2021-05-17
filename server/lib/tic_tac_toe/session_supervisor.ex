defmodule TicTacToe.SessionSupervisor do
  use DynamicSupervisor

  def start_link(init_args) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def start_child(session_id) do
    spec = {TicTacToe.Session, session_id}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(init_args) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [init_args])
  end
end
