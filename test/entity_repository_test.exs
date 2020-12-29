defmodule SimpleSearchEngine.EntityRepositoryTest do
  use ExUnit.Case
  alias Repositories.EntityRepository
  require Logger

  test "Create a new index on Elasticsearch" do
     {db_conn, _} = EntityRepository.create_index()
     assert db_conn == :ok
  end 
  
  test "Check for an existent index" do
    existent = "entities"
    unexistent = "another"
    
    {db_conn1, exist}   = EntityRepository.exist_index?(existent)
    {db_conn2, unexist} = EntityRepository.exist_index?(unexistent)
    
    assert {db_conn1, exist}  === {:ok, true}
    assert {db_conn2, unexist} === {:ok, false}

  end 
  
  test "Insert a new documemt to the index." do
    response = EntityRepository.index_entity(%{ title: "Some title", type: "TOPIC"})
    assert response === {:ok, 201}
  end

  test "Search a document into an index." do
    founded = "som"
    not_found = "sdfsdafdsaf"
    
    {db_conn1, empty_result}  = EntityRepository.search_entity(not_found)
    {db_conn2, filled_result} = EntityRepository.search_entity(founded)

    assert {db_conn1, empty_result}  === {:ok, []}
    assert {db_conn2, filled_result} === {:ok, filled_result} 
  end
end    

