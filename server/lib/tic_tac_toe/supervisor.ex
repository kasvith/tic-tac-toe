defmodule TicTacToe.SessionSupervisor do
  @moduledoc """
  Supervisor to handle creation of dynamic processes to handle new and existing sessions
  """

  use DynamicSupervisor

  @doc """
  Start the supervisor
  """
  def start_link(args) do
    IO.puts("SessionSupervisor starting...")
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc false
  @impl true
  def init(args), do: DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [args])

  @doc """
  Each process is a tied to a session id
  """
  def get_process(id) do
    if process_exists?(id) do
      {:ok, id}
    else
      id |> create_process
    end
  end

  @doc """
  Determines if a process exists already
  """
  def process_exists?(id) do
    case Registry.lookup(TicTacToe.SessionRegistry, "#{id}") do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Create a new process if it doesn't already exist
  """
  def create_process(id) do
    spec = %{id: id, start: {User, :start_link, [id]}}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, _pid} -> {:ok, id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end
end
