defmodule Mx.Modifier.Inline do
  use Mc.Modifier

  def m(buffer, _args, mappings) do
    Mc.Modifier.Buffer.m("", buffer, mappings)
    |> oops(:script_error, buffer) 
  end
end
