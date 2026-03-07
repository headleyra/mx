defmodule Mx.Modifier.Max do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    Mx.Math.applyf(buffer, &Enum.max/1)
  end
end
