defmodule Wordle.DictionaryTest do
  use ExUnit.Case, async: true

  alias Wordle.Dictionary

  describe "answers/0" do
    test "returns a list of words" do
      answers = Dictionary.answers()
      assert is_list(answers)
      assert length(answers) > 0
    end

    test "all answers are 5-letter lowercase strings" do
      for word <- Dictionary.answers() do
        assert String.length(word) == 5, "Expected 5 letters, got #{inspect(word)}"
        assert word == String.downcase(word), "Expected lowercase, got #{inspect(word)}"
      end
    end

    test "returns the same list on repeated calls" do
      assert Dictionary.answers() == Dictionary.answers()
    end
  end

  describe "valid_words/0" do
    test "returns a list of words" do
      valid_words = Dictionary.valid_words()
      assert is_list(valid_words)
      assert length(valid_words) > 0
    end

    test "all valid words are 5-letter lowercase strings" do
      for word <- Dictionary.valid_words() do
        assert String.length(word) == 5, "Expected 5 letters, got #{inspect(word)}"
        assert word == String.downcase(word), "Expected lowercase, got #{inspect(word)}"
      end
    end
  end
end
