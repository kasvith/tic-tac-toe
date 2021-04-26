defmodule TicTacToe.Game.Test do
  use ExUnit.Case

  test "empty game" do
    game = TicTacToe.Game.new()
    assert game.board == [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    assert game.current_player == :x
  end

  test "allow valid moves" do
    game = TicTacToe.Game.new()
    result = TicTacToe.Game.move(game, :x, 0)
    assert {:ok, new_game} = result
    assert %{board: [:x, nil, nil, nil, nil, nil, nil, nil, nil]} = new_game
  end

  test "disallow invalid moves" do
    game = TicTacToe.Game.new()
    result = TicTacToe.Game.move(game, :o, 0)
    assert {:error, _} = result
  end

  test "gives correct board full" do
    empty_board = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    full_board = [:x, :x, :x, :o, :o, :o, :x, :x, :x]
    assert TicTacToe.Game.board_full?(empty_board) === false
    assert TicTacToe.Game.board_full?(full_board) === true
  end

  test "gives correct can move" do
    game = TicTacToe.Game.new()
    {:ok, game} = TicTacToe.Game.move(game, :x, 0)

    assert TicTacToe.Game.can_move?(game, 0) === false
  end

  test "win row" do
    row_1 = [:x, :x, :x, :o, :x, :o, :x, :o, :x]
    row_2 = [:o, :x, :o, :x, :x, :x, :x, :o, :x]
    row_3 = [:x, :o, :x, :o, :x, :o, :x, :x, :x]
    row_4 = [:x, :o, :x, nil, nil, nil, nil, nil, nil]

    assert TicTacToe.Game.get_winner(row_1) === :x
    assert TicTacToe.Game.get_winner(row_2) === :x
    assert TicTacToe.Game.get_winner(row_3) === :x
    assert TicTacToe.Game.get_winner(row_4) === nil
  end

  test "win column" do
    col_1 = [:o, nil, nil, :o, nil, nil, :o, nil, nil]
    col_2 = [nil, :o, nil, nil, :o, nil, nil, :o, nil]
    col_3 = [nil, nil, :o, nil, nil, :o, nil, nil, :o]
    col_4 = [:x, nil, nil, :o, nil, nil, :o, nil, nil]

    assert TicTacToe.Game.get_winner(col_1) === :o
    assert TicTacToe.Game.get_winner(col_2) === :o
    assert TicTacToe.Game.get_winner(col_3) === :o
    assert TicTacToe.Game.get_winner(col_4) === nil
  end

  test "tie" do
    board = [:o, :x, :o, :x, :o, :x, :x, :o, :x]

    assert TicTacToe.Game.get_winner(board) === nil
  end
end
