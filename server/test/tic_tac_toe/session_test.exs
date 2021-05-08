defmodule TicTacToe.Session.Test do
  use ExUnit.Case

  test "allow joining a session" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")
    assert {:ok, :x} = TicTacToe.Session.join_game(pid, "1")
    assert {:ok, :o} = TicTacToe.Session.join_game(pid, "2")
  end

  test "dont allow joining when room is full" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")
    assert {:ok, :x} = TicTacToe.Session.join_game(pid, "1")
    assert {:ok, :o} = TicTacToe.Session.join_game(pid, "2")
    assert {:error, "room full"} = TicTacToe.Session.join_game(pid, "1000")
  end

  test "allow leaving a session" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")

    assert {:ok, :x} = TicTacToe.Session.join_game(pid, "1")
    assert {:ok, :o} = TicTacToe.Session.join_game(pid, "2")

    # leave 1
    TicTacToe.Session.leave_game(pid, "1")

    # new user id can now login as X
    assert {:ok, :x} = TicTacToe.Session.join_game(pid, "100")
  end

  test "allow valid moves" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")
    TicTacToe.Session.join_game(pid, "1")
    TicTacToe.Session.join_game(pid, "2")

    assert :ok = TicTacToe.Session.move(pid, "1", 0)
    assert :ok = TicTacToe.Session.move(pid, "2", 1)
    assert :ok = TicTacToe.Session.move(pid, "1", 8)
  end

  test "update winners" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")
    TicTacToe.Session.join_game(pid, "1")
    TicTacToe.Session.join_game(pid, "2")

    assert :ok = TicTacToe.Session.move(pid, "1", 0)
    assert :ok = TicTacToe.Session.move(pid, "2", 1)
    assert :ok = TicTacToe.Session.move(pid, "1", 6)
    assert :ok = TicTacToe.Session.move(pid, "2", 2)
    assert :ok = TicTacToe.Session.move(pid, "1", 3)
    assert %{"1" => 1, "2" => 0} = TicTacToe.Session.get_stats(pid)
  end

  test "disallow invalid moves" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")
    TicTacToe.Session.join_game(pid, "1")
    TicTacToe.Session.join_game(pid, "2")

    assert :ok = TicTacToe.Session.move(pid, "1", 0)
    assert {:error, _reason} = TicTacToe.Session.move(pid, "2", 0)
  end

  test "gets game" do
    {:ok, pid} = TicTacToe.Session.start_link("game1")

    assert TicTacToe.Session.get_game(pid) == nil
  end
end
