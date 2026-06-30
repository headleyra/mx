defmodule Mx.Modifier.Have do
  use Mc.Modifier

  def m(_buffer, args, mappings) do
    case String.split(args) do
      [key] ->
        add_date(key, mappings)

      [key, "show"] ->
        show(key, mappings)

      _parse_error ->
        oops(:parse_error, args)
    end
  end

  defp add_date(key, mappings) do
    script = """
    get #{key}
    trap
    buffer {}; {date}
    trim
    set #{key}
    date
    """

    Mc.m(script, mappings)
  end

  defp show(key, mappings) do
    yesterday = Date.utc_today() |> Date.add(-1)

    with \
      {:ok, date_str} <- Mc.m("get #{key}", mappings),
      {false, date_str} <- {String.match?(date_str, ~r/^\s*$/), date_str}
    do
      date_str
      |> Mx.Have.stats(yesterday)
      |> render(date_str)
    else
      {true, date_str} ->
        oops(:bad_dates, date_str)

      {:error, _, :key_not_found, not_found_key, []} ->
        oops(:date_key_not_found, not_found_key)
    end
  end

  defp render(stats, date_str) do
    case stats do
      {:error, :parse} ->
        oops(:bad_dates, date_str)

      s ->
        intervals =
          s.int
          |> Enum.reverse()
          |> Enum.join(", ")

        result = """
        one: #{s.one}
        hav: #{s.hav}
        tot: #{s.tot}
        avg: #{s.avg}
        int: #{intervals}
        """

        {:ok, String.trim_trailing(result)}
    end
  end
end
