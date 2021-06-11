defmodule Utils.Json do
  def json_encode!(data, opts \\ []) do
    Jason.encode!(data, opts)
  end

  def json_decode(input, opts \\ []) do
    Jason.decode(input, opts)
  end

  defmacro wrap_data(data) do
    quote do
      %{data: unquote(data)}
    end
  end

  defmacro wrap_error(err) do
    quote do
      %{error: unquote(err)}
    end
  end
end
