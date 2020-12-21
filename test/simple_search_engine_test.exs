defmodule SimpleSearchEngineTest do
  use ExUnit.Case
  doctest SimpleSearchEngine

  test "greets the world" do
    assert SimpleSearchEngine.hello() == :world
  end
end
