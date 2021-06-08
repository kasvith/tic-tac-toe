defmodule TicTacToe.Lobby do
  def generate_game_session_id() do
    id = Nanoid.generate(10)

    case is_game_started?(id) do
      false -> id
      true -> generate_game_session_id()
    end
  end

  def is_game_started?(id) do
    case Registry.lookup(TicTacToe.SessionRegistry, id) do
      [{pid, _}] -> Process.alive?(pid)
      [] -> false
    end
  end
end
