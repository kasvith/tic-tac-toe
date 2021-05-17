defmodule TicTacToe.Session.Test do
  use ExUnit.Case
  @moduletag :capture_log

  setup do
    start_supervised!(TicTacToe.Supervisor)
    :ok
  end

  test "allow joining a session" do
    TicTacToe.SessionSupervisor.start_child("game1")
    assert {:ok, :x} = TicTacToe.Session.join_game("game1", "1")
    assert {:ok, :o} = TicTacToe.Session.join_game("game1", "2")
  end

  test "dont allow joining when room is full" do
    TicTacToe.SessionSupervisor.start_child("game1")
    assert {:ok, :x} = TicTacToe.Session.join_game("game1", "1")
    assert {:ok, :o} = TicTacToe.Session.join_game("game1", "2")
    assert {:error, "room full"} = TicTacToe.Session.join_game("game1", "1000")
  end

  test "allow leaving a session" do
    TicTacToe.SessionSupervisor.start_child("game1")

    assert {:ok, :x} = TicTacToe.Session.join_game("game1", "1")
    assert {:ok, :o} = TicTacToe.Session.join_game("game1", "2")

    # leave 1
    TicTacToe.Session.leave_game("game1", "1")

    # new user id can now login as X
    assert {:ok, :x} = TicTacToe.Session.join_game("game1", "100")
  end

  test "allow valid moves" do
    TicTacToe.SessionSupervisor.start_child("game1")

    TicTacToe.Session.join_game("game1", "1")
    TicTacToe.Session.join_game("game1", "2")

    assert {:ok, "2"} = TicTacToe.Session.move("game1", "1", 0)
    assert {:ok, "1"} = TicTacToe.Session.move("game1", "2", 1)
    assert {:ok, "2"} = TicTacToe.Session.move("game1", "1", 8)
  end

  test "update winners" do
    TicTacToe.SessionSupervisor.start_child("game1")
    {:ok, :x} = TicTacToe.Session.join_game("game1", "1")
    {:ok, :o} = TicTacToe.Session.join_game("game1", "2")

    assert {:ok, "2"} = TicTacToe.Session.move("game1", "1", 0)
    assert {:ok, "1"} = TicTacToe.Session.move("game1", "2", 1)
    assert {:ok, "2"} = TicTacToe.Session.move("game1", "1", 6)
    assert {:ok, "1"} = TicTacToe.Session.move("game1", "2", 2)
    assert {:ok, "2"} = TicTacToe.Session.move("game1", "1", 3)
    assert %{"1" => 1, "2" => 0} = TicTacToe.Session.get_stats("game1")
  end

  test "disallow invalid moves" do
    TicTacToe.SessionSupervisor.start_child("game1")
    {:ok, :x} = TicTacToe.Session.join_game("game1", "1")
    {:ok, :o} = TicTacToe.Session.join_game("game1", "2")

    assert {:ok, "2"} = TicTacToe.Session.move("game1", "1", 0)
    assert {:error, _reason} = TicTacToe.Session.move("game1", "2", 0)
  end

  test "gets game" do
    TicTacToe.SessionSupervisor.start_child("game1")

    assert TicTacToe.Session.get_game("game1") == nil
  end
end
