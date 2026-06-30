defmodule Mx.Modifier.Round do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    with \
      {:ok, number} <- String.trim(buffer) |> Ut.String.to_num(),
      {:ok, precision} when precision in 0..15 <- Ut.String.to_int(args)
    do
      float = to_float(number)
      result = Float.round(float, precision) |> to_string()
      {:ok, result}
    else
      _parse_error ->
        oops(:bad_number_or_precision, nil)
    end
  end

  defp to_float(n) do
    if is_integer(n), do: n * 1.0, else: n
  end
end
