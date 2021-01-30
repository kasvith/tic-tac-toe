defmodule TicTacToe.Session.Test do
  use ExUnit.Case

  test "allow valid moves" do
    {:ok, pid} = TicTacToe.Session.start_link()

    assert :ok = TicTacToe.Session.move(pid, "X", 0)
    assert :ok = TicTacToe.Session.move(pid, "O", 1)
    assert :ok = TicTacToe.Session.move(pid, "X", 8)
  end

  test "disallow invalid moves" do
    {:ok, pid} = TicTacToe.Session.start_link()

    assert :ok = TicTacToe.Session.move(pid, "X", 0)
    assert {:error, _reason} = TicTacToe.Session.move(pid, "O", 0)
  end

  test "gives correct status after a move" do
    {:ok, pid} = TicTacToe.Session.start_link()

    assert :ok = TicTacToe.Session.move(pid, "X", 0)

    assert {:winner, nil, :board_full, false, :player, "O"} = TicTacToe.Session.get_status(pid)
  end
end
