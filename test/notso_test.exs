defmodule NotsoTest do
  use ExUnit.Case
  doctest Notso

  test "greets the world" do
    assert Notso.hello() == :world
  end
end
