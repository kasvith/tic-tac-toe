defmodule Utils.String do
  def empty?(nil), do: true

  def empty?(str) do
    "" == str |> to_string |> String.trim()
  end
end
