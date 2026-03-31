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

  def mark_characters(game, guess) do
    game.answer
    |> String.graphemes()
    |> Enum.zip(String.graphemes(guess))
    |> Enum.map(&compare_greens/1)
    |> mark_yellows()
  end

  def compare_greens({answer, guess}) do
    color = if answer == guess, do: :green, else: :gray
    {answer, guess, color}
  end

  def mark_yellows(marks) do
    yellow_or_gray =
      marks
      |> Enum.filter(fn {_, _, color} -> color == :gray end)

    answers = Enum.map(yellow_or_gray, fn {a, _g, _color} -> a end)

    guesses = Enum.map(yellow_or_gray, fn {_, g, _color} -> g end)

    greys = guesses -- answers

    mark_rest(marks, greys, [])
  end

  def mark_rest([], _greys, acc), do: Enum.reverse(acc)

  def mark_rest([{a, g, color} | marks], greys, acc) do
    cond do
      color == :green ->
        mark_rest(marks, greys, [{a, g, :green} | acc])

      g in greys ->
        mark_rest(marks, List.delete(greys, g), [{a, g, :grey} | acc])

      true ->
        mark_rest(marks, greys, [{a, g, :yellow} | acc])
    end
  end
end
