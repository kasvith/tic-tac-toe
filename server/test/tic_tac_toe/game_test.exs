defmodule TicTacToe.Game.Test do
  use ExUnit.Case

  test "empty game" do
    game = TicTacToe.Game.new()
    assert game.board == [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    assert game.current_player == "X"
  end

  test "allow valid moves" do
    game = TicTacToe.Game.new()
    result = TicTacToe.Game.move(game, "X", 0)
    assert {:ok, new_game} = result
    assert %{board: ["X", nil, nil, nil, nil, nil, nil, nil, nil]} = new_game
  end

  test "disallow invalid moves" do
    game = TicTacToe.Game.new()
    result = TicTacToe.Game.move(game, "O", 0)
    assert {:error, _} = result
  end

  test "gives correct next player" do
    game = TicTacToe.Game.new()
    next_player = TicTacToe.Game.next_player(game.current_player)
    assert next_player === "O"
  end

  test "gives correct board full" do
    empty_board = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    full_board = ["X", "X", "X", "O", "O", "O", "X", "X", "X"]
    assert TicTacToe.Game.board_full?(empty_board) === false
    assert TicTacToe.Game.board_full?(full_board) === true
  end

  test "gives correct can move" do
    game = TicTacToe.Game.new()
    {:ok, game} = TicTacToe.Game.move(game, "X", 0)

    assert TicTacToe.Game.can_move?(game, 0) === false
  end

  test "win row" do
    row_1 = ["X", "X", "X", nil, nil, nil, nil, nil, nil]
    row_2 = [nil, nil, nil, "X", "X", "X", nil, nil, nil]
    row_3 = [nil, nil, nil, nil, nil, nil, "X", "X", "X"]
    row_4 = ["X", "O", "X", nil, nil, nil, nil, nil, nil]

    assert TicTacToe.Game.is_win(row_1) === "X"
    assert TicTacToe.Game.is_win(row_2) === "X"
    assert TicTacToe.Game.is_win(row_3) === "X"
    assert TicTacToe.Game.is_win(row_4) === nil
  end

  test "win column" do
    col_1 = ["O", nil, nil, "O", nil, nil, "O", nil, nil]
    col_2 = [nil, "O", nil, nil, "O", nil, nil, "O", nil]
    col_3 = [nil, nil, "O", nil, nil, "O", nil, nil, "O"]
    col_4 = ["X", nil, nil, "O", nil, nil, "O", nil, nil]

    assert TicTacToe.Game.is_win(col_1) === "O"
    assert TicTacToe.Game.is_win(col_2) === "O"
    assert TicTacToe.Game.is_win(col_3) === "O"
    assert TicTacToe.Game.is_win(col_4) === nil
  end

  test "tie" do
    board = ["O", "X", "O", "X", "O", "X", "O", "X", "X"]

    assert TicTacToe.Game.is_win(board) === nil
  end
end
