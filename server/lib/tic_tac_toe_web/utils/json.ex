defmodule Utils.Json do
  def json_encode!(data, opts \\ []) do
    Jason.encode!(data, opts)
  end

  def json_decode(input, opts \\ []) do
    Jason.decode(input, opts)
  end

  def wrap_data(data) do
    %{data: data}
  end

  def wrap_error(err) do
    %{error: err}
  end
end
