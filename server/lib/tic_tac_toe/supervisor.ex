defmodule TicTacToe.SessionSupervisor do
  @moduledoc """
  Supervisor to handle creation of dynamic processes to handle new and existing sessions
  """

  use DynamicSupervisor

  alias TicTacToe.Session

  @doc """
  Start the supervisor
  """
  def start_link(args) do
    IO.puts("SessionSupervisor starting with #{inspect(args)}")
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc false
  @impl true
  def init(_args), do: DynamicSupervisor.init(strategy: :one_for_one)

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
    spec = %{id: Session, start: {Session, :start_link, [id]}}

    case DynamicSupervisor.start_child(__MODULE__, Supervisor.child_spec(spec, [])) do
      {:ok, _pid} -> {:ok, id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end
end
