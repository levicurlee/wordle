defmodule Wordle.GameTest do
  use ExUnit.Case, async: true

  alias Wordle.Game
  alias Wordle.Dictionary

  describe "new/0" do
    test "creates a game with an answer from the dictionary" do
      game = Game.new()
      assert game.answer in Dictionary.answers()
    end

    test "starts with no guesses" do
      game = Game.new()
      assert game.guesses == []
    end
  end

  describe "make_guess/2" do
    test "adds a guess to the list" do
      game = Game.new()
      game = Game.make_guess(game, "hello")
      assert game.guesses == ["hello"]
    end

    test "appends subsequent guesses in order" do
      game =
        Game.new()
        |> Game.make_guess("hello")
        |> Game.make_guess("world")
        |> Game.make_guess("crane")

      assert game.guesses == ["hello", "world", "crane"]
    end

    test "does not change the answer" do
      game = Game.new()
      original_answer = game.answer
      game = Game.make_guess(game, "hello")
      assert game.answer == original_answer
    end
  end

  describe "count_greens/2" do
    test "counts correct letters in the correct position" do
      game = %Game{answer: "crane", guesses: []}
      assert Game.count_greens(game, "crane") == 5
      assert Game.count_greens(game, "crank") == 4
      assert Game.count_greens(game, "cable") == 2
      assert Game.count_greens(game, "grape") == 3
      assert Game.count_greens(game, "plane") == 3
      assert Game.count_greens(game, "hello") == 0
    end

    test "handles guesses of different lengths" do
      game = %Game{answer: "crane", guesses: []}
      assert Game.count_greens(game, "cran") == 4
      assert Game.count_greens(game, "cranex") == 5
    end

    test "handles empty guess" do
      game = %Game{answer: "crane", guesses: []}
      assert Game.count_greens(game, "") == 0
    end
  end

end
