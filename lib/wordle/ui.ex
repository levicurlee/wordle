defmodule Wordle.UI do
  @moduledoc """
  Terminal rendering for the Wordle game — tiles and keyboard.
  """

  @keyboard_rows [
    ~w(q w e r t y u i o p),
    ~w(a s d f g h j k l),
    ~w(z x c v b n m)
  ]

  @empty_tile IO.ANSI.light_black() <> "  _  " <> IO.ANSI.reset()

  def render_board(state) do
    clear_screen()
    IO.puts("\n  === WORDLE ===\n")

    Enum.each(state.marks_history, &render_tile_row/1)

    empty_rows = state.remaining
    Enum.each(1..max(empty_rows, 0)//1, fn _ -> render_empty_row() end)

    IO.puts("")
    render_keyboard(state.keyboard)
    IO.puts("")
  end

  def render_win, do: IO.puts(color(:green, "  Congratulations! You got it!"))
  def render_loss(answer), do: IO.puts(color(:red, "  Game over! The answer was: #{answer}"))

  def render_error(:invalid_length), do: IO.puts("  Guess must be exactly 5 letters.")
  def render_error(:not_in_dictionary), do: IO.puts("  Not a valid word.")
  def render_error(:game_over), do: IO.puts("  Game is already over. Start a new game.")
  def render_error(_), do: IO.puts("  Something went wrong.")

  def prompt, do: IO.gets("  Enter guess: ")

  def welcome do
    clear_screen()
    IO.puts("\n  === WORDLE ===")
    IO.puts("  Guess the 5-letter word. You have 6 attempts.\n")

    Enum.each(1..6, fn _ -> render_empty_row() end)
    IO.puts("")
    render_keyboard(%{})
    IO.puts("")
  end

  # Tiles

  defp render_tile_row(marks) do
    marks
    |> Enum.map(&tile/1)
    |> Enum.join(" ")
    |> then(&IO.puts("  #{&1}"))
  end

  defp render_empty_row do
    1..5
    |> Enum.map(fn _ -> @empty_tile end)
    |> Enum.join(" ")
    |> then(&IO.puts("  #{&1}"))
  end

  defp tile({_answer, letter, color}) do
    bg = tile_bg(color)
    bg <> IO.ANSI.black() <> "  #{String.upcase(letter)}  " <> IO.ANSI.reset()
  end

  defp tile_bg(:green), do: IO.ANSI.green_background()
  defp tile_bg(:yellow), do: IO.ANSI.yellow_background()
  defp tile_bg(_grey), do: IO.ANSI.light_black_background()

  # Keyboard

  defp render_keyboard(keyboard) do
    Enum.each(@keyboard_rows, fn row ->
      padding = String.duplicate(" ", div(10 - length(row), 2) * 4)

      row
      |> Enum.map(&key(&1, keyboard))
      |> Enum.join(" ")
      |> then(&IO.puts("  #{padding}#{&1}"))
    end)
  end

  defp key(letter, keyboard) do
    case Map.get(keyboard, letter) do
      :green -> color_key(letter, IO.ANSI.green_background())
      :yellow -> color_key(letter, IO.ANSI.yellow_background())
      :grey -> color_key(letter, IO.ANSI.light_black_background())
      nil -> " #{String.upcase(letter)} "
    end
  end

  defp color_key(letter, bg) do
    bg <> IO.ANSI.black() <> " #{String.upcase(letter)} " <> IO.ANSI.reset()
  end

  defp color(color, text) do
    ansi = if color == :green, do: IO.ANSI.green(), else: IO.ANSI.red()
    ansi <> text <> IO.ANSI.reset()
  end

  defp clear_screen, do: IO.write(IO.ANSI.clear() <> IO.ANSI.home())
end
