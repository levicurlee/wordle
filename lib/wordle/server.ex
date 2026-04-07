defmodule Wordle.Server do
  @moduledoc """
  GenServer that holds game state. Handle_call functions are thin wrappers only.
  """

  use GenServer

  alias Wordle.{Game, Validator}

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def new_game, do: GenServer.call(__MODULE__, :new_game)

  def guess(word), do: GenServer.call(__MODULE__, {:guess, word})

  def game_state, do: GenServer.call(__MODULE__, :game_state)

  # Server callbacks

  @impl true
  def init(_opts), do: {:ok, {Game.new(), []}}

  @impl true
  def handle_call(:new_game, _from, _state), do: {:reply, :ok, {Game.new(), []}}

  @impl true
  def handle_call({:guess, word}, _from, state) do
    {reply, new_state} = process_guess(state, word)
    {:reply, reply, new_state}
  end

  @impl true
  def handle_call(:game_state, _from, {game, history} = state) do
    {:reply, build_state(game, history), state}
  end

  # Private

  defp process_guess({game, history}, raw_word) do
    word = raw_word |> String.trim() |> String.downcase()

    with {:ok, guess} <- Validator.validate_guess(game, word) do
      new_game = Game.make_guess(game, guess)
      marks = Game.mark_characters(new_game, guess)
      new_history = history ++ [marks]
      {{:ok, build_state(new_game, new_history)}, {new_game, new_history}}
    else
      error -> {error, {game, history}}
    end
  end

  defp build_state(game, history) do
    %{
      marks_history: history,
      keyboard: Game.keyboard_colors(history),
      remaining: Game.guesses_remaining(game),
      won: Game.won?(game),
      lost: Game.lost?(game),
      game_over: Game.game_over?(game),
      answer: if(Game.game_over?(game), do: game.answer)
    }
  end
end
