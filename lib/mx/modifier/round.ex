defmodule Mx.Modifier.Round do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    with \
      {:num, {:ok, number}} <- {:num, Ut.String.to_num(buffer)},
      {:pre, {:ok, precision}} when precision in 0..15 <- {:pre, Ut.String.to_int(args)}
    do
      float = float(number)
      {:ok, round(float, precision)}
    else
      {:num, {:error, num}} ->
        oops(:bad_number, num)

      {:pre, {:error, pre}} ->
        oops(:bad_precision, pre)

      {:pre, {:ok, pre}} ->
        oops(:bad_precision, "#{pre}")
    end
  end

  defp float(n) do
    if is_integer(n), do: n * 1.0, else: n
  end

  defp round(float, precision) do
    float
    |> Float.round(precision)
    |> to_string()
  end
end
