defmodule Mx.Modifier.PadL do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    with \
      [width, padding] <- String.split(args),
      {:ok, width_int} when width_int > 0 <- Ut.String.to_int(width)
    do
      padding_uri = URI.decode(padding)
      {:ok, String.pad_leading(buffer, width_int, padding_uri)}
    else
      _error_parse ->
        oops(:parse_error, args)
    end
  end
end
