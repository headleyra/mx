defmodule Mx.Modifier.HaveTest do
  use ExUnit.Case, async: false
  alias Mx.Modifier.Have

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{
      "bob" => "2016-7-foo\n2017-01-02 2018-07-05",
      "tim" => " ",
      "jon" => "\n \t",
      "dan" => "#{ago(7)}\n#{ago(5)}",
      "jed" => "#{ago(7)} #{ago(5)} #{ago(3)}",
      "neo" => "#{ago(5)} #{ago(3)} #{ago(0)}",
      "ft1" => "#{ago(0)}",
      "ft2" => "#{ago(0)} #{ago(-1)}"
    }})

    mappings = %{
      get: Mc.Modifier.Get,
      set: Mc.Modifier.Set,
      buffer: Mc.Modifier.Buffer,
      trim: Mc.Modifier.Trim,
      trap: Mx.Modifier.Trap,
      date: Mx.Modifier.Date
    }

    %{mappings: mappings}
  end

  describe "m/3" do
    test "shows stats for a key (up to, and including, yesterday)", %{mappings: mappings} do
      assert Have.m("", "dan show", mappings) == {:ok, "one: #{ago(7)}\nhav: 2\ntot: 7\navg: 2.5\nint: 4, 1"}
      assert Have.m("", "jed show", mappings) == {:ok, "one: #{ago(7)}\nhav: 3\ntot: 7\navg: 1.33\nint: 2, 1, 1"}
      assert Have.m("", "neo show", mappings) == {:ok, "one: #{ago(5)}\nhav: 2\ntot: 5\navg: 1.5\nint: 2, 1"}
    end

    test "works with 'have' days that are in the future", %{mappings: mappings} do
      assert Have.m("", "ft1 show", mappings) == {:ok, "one: n/a\nhav: 0\ntot: 0\navg: 0\nint:"}
      assert Have.m("", "ft2 show", mappings) == {:ok, "one: n/a\nhav: 0\ntot: 0\navg: 0\nint:"}
    end

    test "adds today as a 'have' day", %{mappings: mappings} do
      today = "#{ago(0)}"
      assert Have.m("", "sam", mappings) == {:ok, today}
      assert Mc.m("get sam", mappings) == {:ok, today}
    end

    test "errors when a key doesn't exist", %{mappings: mappings} do
      assert Have.m("", "no.exist show", mappings) == {:error, Mx.Modifier.Have, :date_key_not_found, "no.exist", []}
    end

    test "errors when a key points at bad dates", %{mappings: mappings} do
      assert Have.m("", "bob show", mappings) == {:error, Mx.Modifier.Have, :bad_dates, "2016-7-foo\n2017-01-02 2018-07-05", []}
      assert Have.m("", "tim show", mappings) == {:error, Mx.Modifier.Have, :bad_dates, " ", []}
      assert Have.m("", "jon show", mappings) == {:error, Mx.Modifier.Have, :bad_dates, "\n \t", []}
    end

    test "errors with whitespace", %{mappings: mappings} do
      assert Have.m("", " ", mappings) == {:error, Mx.Modifier.Have, :parse_error, " ", []}
      assert Have.m("", "\t ", mappings) == {:error, Mx.Modifier.Have, :parse_error, "\t ", []}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      today = "#{ago(0)}"
      assert Have.m({:ok, "n/a"}, "sam", mappings) == {:ok, today}
    end

    test "allows error-tuples to pass through" do
      assert Have.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end

  defp ago(days) do
    Date.utc_today()
    |> Date.add(-days)
  end
end
