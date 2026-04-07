defmodule Wordle.Game do
  @moduledoc """
  Functional core for the Wordle game. No tag tuples — pure data in, data out.
  """

  alias Wordle.Dictionary

  @max_guesses 6

  defstruct [:answer, guesses: []]

  def new do
    %__MODULE__{answer: Enum.random(Dictionary.answers())}
  end

  def new(answer), do: %__MODULE__{answer: answer}

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

  def won?(game) do
    game.guesses != [] and List.last(game.guesses) == game.answer
  end

  def lost?(game), do: length(game.guesses) >= @max_guesses and not won?(game)

  def game_over?(game), do: won?(game) or lost?(game)

  def guesses_remaining(game), do: @max_guesses - length(game.guesses)

  def max_guesses, do: @max_guesses

  def keyboard_colors(all_marks) do
    all_marks
    |> List.flatten()
    |> Enum.reduce(%{}, fn {_answer, letter, color}, acc ->
      Map.update(acc, letter, color, &best_color(&1, color))
    end)
  end

  defp best_color(:green, _), do: :green
  defp best_color(_, :green), do: :green
  defp best_color(:yellow, _), do: :yellow
  defp best_color(_, :yellow), do: :yellow
  defp best_color(current, _), do: current

  # Private helpers

  defp compare_greens({answer, guess}) do
    color = if answer == guess, do: :green, else: :gray
    {answer, guess, color}
  end

  defp mark_yellows(marks) do
    yellow_or_gray = Enum.filter(marks, fn {_, _, color} -> color == :gray end)
    answers = Enum.map(yellow_or_gray, fn {a, _, _} -> a end)
    guesses = Enum.map(yellow_or_gray, fn {_, g, _} -> g end)
    greys = guesses -- answers

    mark_rest(marks, greys, [])
  end

  defp mark_rest([], _greys, acc), do: Enum.reverse(acc)

  defp mark_rest([{a, g, color} | marks], greys, acc) do
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
