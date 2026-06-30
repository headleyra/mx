defmodule Mx.Modifier.Random do
  use Mc.Modifier

  def m(_buffer, args, _mappings) do
    case Ut.String.to_int(args) do
      {:ok, integer} when integer > 0 ->
        {:ok, "#{:rand.uniform(integer)}"}

      _bad_args ->
        oops(:foo, "bad random limit")
    end
  end
end
