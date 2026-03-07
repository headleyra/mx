defmodule Mx.Modifier.BufferV do
  use Mc.Modifier

  def m(_buffer, args, _mappings) do
    {:ok, args}
  end
end
