defmodule Mx.Modifier.Exec do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.Modifier.Buffer.m(buffer, args, mappings) do
      {:ok, script} ->
        Mc.m(buffer, script, mappings)

      {:error, _, _, _, _} = error ->
        oops(error, :script_error, args)
    end
  end
end
