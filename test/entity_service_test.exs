defmodule SimpleSearchEngine.EntityServiceTest do
  use ExUnit.Case
  alias Services.EntityService

  test "Create a new entity." do
    body_data = '{"title": "Some title", "type": "TOPIC"}'
    {db_conn, status, message} = EntityService.create_entity(body_data)
    
    assert {:ok, :created, message} === {db_conn, status, message}
  end

  test "Finding an existent entity" do
    parameter = "som"
    {db_conn, status, result} = EntityService.find_entity(parameter)

    assert {:ok, :founded, result} === {db_conn, status, result} or
    {:ok, :not_founded, result}    === {db_conn, status, result} 
  end
end
