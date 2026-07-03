defmodule Mx.Math do
  def applyf(buffer, func) do
    result =
      String.split(buffer, ~r/\s+/)
      |> Enum.map(fn str -> to_number_or_as_is(str) end)
      |> func.()
      |> to_string()

    {:ok, result}
  end

  def to_number_or_as_is(string) do
    case Ut.String.to_num(string) do
      {:error, _} ->
        string

      {:ok, number} ->
        number
    end
  end
end
