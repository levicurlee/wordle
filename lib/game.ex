defmodule Wordle.Game do
  @moduledoc """
  Functional core for the Wordle game.
  """

  alias Wordle.Dictionary

  defstruct [:answer, :guesses]

  def new() do
    %__MODULE__{
      answer: Dictionary.answers() |> Enum.random(),
      guesses: []
    }
  end

  def make_guess(game, guess) do
    %{game | guesses: game.guesses ++ [guess]}
  end

  def count_greens(game, guess) do
    game.answer
    |> String.graphemes()
    |> Enum.zip(String.graphemes(guess))
    |> Enum.count(fn {a, g} -> a == g end)
  end

end
