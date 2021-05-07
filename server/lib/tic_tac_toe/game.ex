defmodule TicTacToe.Game do
  @type position :: integer()
  @type player_type :: :x | :o
  @type board_type :: list(player_type())

  @board for _ <- 1..9, do: nil
  @player_x :x
  @player_o :o

  @type t :: %__MODULE__{
          board: board_type(),
          current_player: player_type()
        }
  defstruct board: @board,
            current_player: @player_x

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
  @spec move(t(), player_type(), integer()) ::
          {:error, String.t()} | {:ok, t()}
  def move(game, player, position)
      when player in [@player_x, @player_o] and
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
  @spec can_move?(t(), integer()) :: boolean()
  def can_move?(%TicTacToe.Game{board: board}, position) do
    !get_winner(board) && !board_full?(board) && Enum.at(board, position) === nil
  end

  defp is_current_player?(game, player) do
    game.current_player === player
  end

  @spec next_player(player_type()) :: player_type()
  defp next_player(player) when player in [@player_x, @player_o] do
    case player do
      @player_x -> @player_o
      @player_o -> @player_x
    end
  end

  @doc """
  get the winner of game `board`
  """
  @spec get_winner(board_type()) :: player_type() | nil
  def get_winner([a, a, a, _, _, _, _, _, _] = _board) when a != nil, do: a
  def get_winner([_, _, _, a, a, a, _, _, _] = _board) when a != nil, do: a
  def get_winner([_, _, _, _, _, _, a, a, a] = _board) when a != nil, do: a
  def get_winner([a, _, _, a, _, _, a, _, _] = _board) when a != nil, do: a
  def get_winner([_, a, _, _, a, _, _, a, _] = _board) when a != nil, do: a
  def get_winner([_, _, a, _, _, a, _, _, a] = _board) when a != nil, do: a
  def get_winner([a, _, _, _, a, _, _, _, a] = _board) when a != nil, do: a
  def get_winner([_, _, a, _, a, _, a, _, _] = _board) when a != nil, do: a
  def get_winner(_), do: nil

  @doc """
  is `board` full
  """
  @spec board_full?(board_type()) :: boolean
  def board_full?(board) do
    !Enum.any?(board, &is_nil/1)
  end

  @spec get_state(t()) :: {:ok, atom()}
  def get_state(%TicTacToe.Game{board: board}) do
    cond do
      get_winner(board) != nil ->
        {:ok, :winner}

      board_full?(board) == true ->
        {:ok, :tie}

      true ->
        {:ok, :continue}
    end
  end
end
