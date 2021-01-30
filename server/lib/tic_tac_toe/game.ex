defmodule TicTacToe.Game do
  @board for _ <- 1..9, do: nil
  @player "X"
  @opponent "O"

  defstruct board: @board,
            current_player: @player

  @doc """
  Creates a new game
  """
  @spec new :: %TicTacToe.Game{}
  def new() do
    %TicTacToe.Game{}
  end

  @doc """
  moves `player` to `position` in `game`
  """
  @spec move(%TicTacToe.Game{}, String.t(), integer()) ::
          {:error, String.t()} | {:ok, %TicTacToe.Game{}}
  def move(game, player, position)
      when player in [@player, @opponent] and
             is_number(position) and
             position >= 0 and position <= 8 do
    if is_current_player?(game, player) && can_move?(game, position) do
      {
        :ok,
        %TicTacToe.Game{
          game
          | board: List.update_at(game.board, position, fn _ -> player end),
            current_player: next_player(player)
        }
      }
    else
      {:error, "invalid move"}
    end
  end

  def move(_game, _player, _position) do
    {:error, "invalid player"}
  end

  @doc """
  can move to the `position`
  """
  @spec can_move?(%TicTacToe.Game{}, integer) :: boolean
  def can_move?(game, position) do
    !get_winner(game.board) && !board_full?(game.board) && Enum.at(game.board, position) === nil
  end

  defp is_current_player?(game, player) do
    game.current_player === player
  end

  @doc """
  get the next player based on `player`
  """
  @spec next_player(String.t()) :: String.t()
  def next_player(player) when player in [@player, @opponent] do
    case player do
      @player -> @opponent
      @opponent -> @player
    end
  end

  @doc """
  get the winner of game `board`
  """
  @spec get_winner(list()) :: String.t() | nil
  def get_winner([a, a, a, _, _, _, _, _, _] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([_, _, _, a, a, a, _, _, _] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([_, _, _, _, _, _, a, a, a] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([a, _, _, a, _, _, a, _, _] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([_, a, _, _, a, _, _, a, _] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([_, _, a, _, _, a, _, _, a] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([a, _, _, _, a, _, _, _, a] = _board) when is_nil(a) === false do
    a
  end

  def get_winner([_, _, a, _, a, _, a, _, _] = _board) when is_nil(a) === true do
    a
  end

  def get_winner(_) do
    nil
  end

  @doc """
  is `board` full
  """
  @spec board_full?(list()) :: boolean
  def board_full?(board) do
    !Enum.any?(board, &is_nil/1)
  end
end
