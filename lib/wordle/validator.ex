defmodule Wordle.Validator do
  @moduledoc """
  Validation layer for Wordle guesses. Tag tuples live here, not in the functional core.
  """

  alias Wordle.{Dictionary, Game}

  def validate_guess(game, guess) do
    with :ok <- check_game_active(game),
         :ok <- check_length(guess),
         :ok <- check_valid_word(guess) do
      {:ok, guess}
    end
  end

  defp check_game_active(game) do
    if Game.game_over?(game), do: {:error, :game_over}, else: :ok
  end

  defp check_length(guess) do
    if String.length(guess) == 5, do: :ok, else: {:error, :invalid_length}
  end

  defp check_valid_word(guess) do
    if guess in Dictionary.answers() or guess in Dictionary.valid_words(),
      do: :ok,
      else: {:error, :not_in_dictionary}
  end
end
