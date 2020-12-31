defmodule SimpleSearchEngine.EntityServiceTest do
  use ExUnit.Case
  alias Services.EntityService

  test "Create a new entity." do
    body_data = '{"title": "Some title", "type": "TOPIC"}'
    assert {:ok, :created, _} = EntityService.create_entity(body_data)
  end

  test "Finding an existent entity" do
    parameter = %{"q" => "som"}
    invalid_param = %{"q" => "fsda78f79sdf907afdsfsdaf"}
    assert {:ok, :founded, _} = EntityService.find_entity(parameter) 
    assert {:error, :not_founded, _} = EntityService.find_entity(invalid_param)
  end
end
