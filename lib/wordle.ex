defmodule Wordle do
  @moduledoc """
  Public API and terminal game loop for Wordle.
  """

  alias Wordle.{Server, UI}

  def play do
    Server.start_link()
    UI.welcome()
    game_loop()
  end

  defp game_loop do
    guess = UI.prompt()
    handle_guess(guess)
  end

  defp handle_guess(:eof), do: IO.puts("\nGoodbye!")

  defp handle_guess(input) do
    with {:ok, state} <- Server.guess(input) do
      UI.render_board(state)
      check_end(state)
    else
      {:error, reason} ->
        UI.render_error(reason)
        game_loop()
    end
  end

  defp check_end(%{won: true}), do: UI.render_win()
  defp check_end(%{lost: true, answer: answer}), do: UI.render_loss(answer)
  defp check_end(_state), do: game_loop()
end
