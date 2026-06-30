defmodule Mx.Modifier.IfTest do
  use ExUnit.Case, async: true
  alias Mx.Modifier.If

  setup do
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `args` as: <sep> <regex><sep> <true script><sep> <false script>", do: true
    test "runs <true script> if <regex> matches `buffer` else runs <false script>", do: true

    test "works", %{mappings: mappings} do
      assert If.m("foo", ", fo, b true dat, b nah!", mappings) == {:ok, "true dat"}
      assert If.m("more stuff", ": ff$: b yep: b nah", mappings) == {:ok, "yep"}
      assert If.m("howdy", ", h.wdi, date, range 3", mappings) == {:ok, "1\n2\n3"}
    end

    test "runs against the `buffer`", %{mappings: mappings} do
      assert If.m("foo", ", no-match, b foo, append -bar", mappings) == {:ok, "foo-bar"}
    end

    @err {:error, Mx.Modifier.If, :parse_error, nil, []}

    test "detects parse errors" do
      assert If.m("n/a", "", %{}) == @err
      assert If.m("", ", regx-only", %{}) == @err
      assert If.m("", ", regx, true-script-only", %{}) == @err
    end


    test "errors when regex is bad" do
      assert If.m("dosh", ", ?, b true, b false", %{}) == {:error, Mx.Modifier.If, :bad_regex, nil, []}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert If.m({:ok, "aaa"}, ", aa., b t, b f", mappings) == {:ok, "t"}
      assert If.m({:ok, "aaa"}, ", aab, b t, b f", mappings) == {:ok, "f"}
    end

    test "allows error-tuples to pass through" do
      assert If.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
