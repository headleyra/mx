defmodule Mx.Modifier.If do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    with \
      [regx_str, true_script, false_script] <- Ut.Parse.split(args),
      {:ok, regx} <- Regex.compile(regx_str)
    do
      script = if String.match?(buffer, regx), do: true_script, else: false_script
      Mc.m(buffer, script, mappings)
    else
      {:error, _} ->
        oops(:bad_regex, args)

      _parse_error ->
        oops(:parse_error, args)
    end
  end
end
