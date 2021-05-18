defmodule TicTacToe.Session.Test do
  use ExUnit.Case, async: false
  @moduletag :capture_log

  @game "game"

  setup do
    {:ok, _} = TicTacToe.SessionSupervisor.start_child(@game)

    on_exit(fn ->
      case TicTacToe.Session.whereis(@game) do
        pid -> Process.exit(pid, :kill)
      end
    end)
  end

  test "allow joining a session" do
    assert {:ok, :x} = TicTacToe.Session.join_game(@game, "1")
    assert {:ok, :o} = TicTacToe.Session.join_game(@game, "2")
  end

  test "dont allow joining when room is full" do
    assert {:ok, :x} = TicTacToe.Session.join_game(@game, "1")
    assert {:ok, :o} = TicTacToe.Session.join_game(@game, "2")
    assert {:error, "room full"} = TicTacToe.Session.join_game(@game, "1000")
  end

  test "allow leaving a session" do
    assert {:ok, :x} = TicTacToe.Session.join_game(@game, "1")
    assert {:ok, :o} = TicTacToe.Session.join_game(@game, "2")

    # leave 1
    TicTacToe.Session.leave_game(@game, "1")

    # new user id can now login as X
    assert {:ok, :x} = TicTacToe.Session.join_game(@game, "100")
  end

  test "allow valid moves" do
    TicTacToe.Session.join_game(@game, "1")
    TicTacToe.Session.join_game(@game, "2")

    assert {:ok, "2"} = TicTacToe.Session.move(@game, "1", 0)
    assert {:ok, "1"} = TicTacToe.Session.move(@game, "2", 1)
    assert {:ok, "2"} = TicTacToe.Session.move(@game, "1", 8)
  end

  test "update winners" do
    {:ok, :x} = TicTacToe.Session.join_game(@game, "1")
    {:ok, :o} = TicTacToe.Session.join_game(@game, "2")

    assert {:ok, "2"} = TicTacToe.Session.move(@game, "1", 0)
    assert {:ok, "1"} = TicTacToe.Session.move(@game, "2", 1)
    assert {:ok, "2"} = TicTacToe.Session.move(@game, "1", 6)
    assert {:ok, "1"} = TicTacToe.Session.move(@game, "2", 2)
    assert {:ok, "2"} = TicTacToe.Session.move(@game, "1", 3)
    assert %{"1" => 1, "2" => 0} = TicTacToe.Session.get_stats(@game)
  end

  test "disallow invalid moves" do
    {:ok, :x} = TicTacToe.Session.join_game(@game, "1")
    {:ok, :o} = TicTacToe.Session.join_game(@game, "2")

    assert {:ok, "2"} = TicTacToe.Session.move(@game, "1", 0)
    assert {:error, _reason} = TicTacToe.Session.move(@game, "2", 0)
  end

  test "gets game" do
    assert TicTacToe.Session.get_game(@game) == nil
  end
end
