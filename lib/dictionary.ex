defmodule Wordle.Dictionary do
  @moduledoc """
  Dictionary module for Wordle game based on words in the words directory.
  """

  @answers_path Path.join([__DIR__, "..", "words", "answers.txt"]) |> Path.expand()
  @valid_words_path Path.join([__DIR__, "..", "words", "valid-guesses.txt"]) |> Path.expand()

  @external_resource @answers_path
  @external_resource @valid_words_path

  @answers @answers_path |> File.read!() |> String.split("\n", trim: true)
  @valid_words @valid_words_path |> File.read!() |> String.split("\n", trim: true)

  def answers, do: @answers

  def valid_words, do: @valid_words
end
