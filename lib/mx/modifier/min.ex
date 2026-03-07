defmodule Mx.Modifier.Min do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    Mx.Math.applyf(buffer, &Enum.min/1)
  end
end
