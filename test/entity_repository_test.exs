defmodule SimpleSearchEngine.EntityRepositoryTest do
  use ExUnit.Case
  alias Repositories.EntityRepository

  test "Create a new index on Elasticsearch" do
     
    assert {:ok, _} =  EntityRepository.create_index()
  end 
  
  test "Check for an existent index" do
    existent = "entities"
    unexistent = "another_index"
    
    assert {:ok, true } = EntityRepository.exist_index?(existent)
    assert {:ok, false} = EntityRepository.exist_index?(unexistent)
  end 
  
  test "Insert a new documemt to the index." do
    assert {:ok, 201} = EntityRepository.index_entity(%{ title: "Some title", type: "TOPIC"})
  end

  test "Search a document into an index." do
    
    founded   = %{"q" => "som"}               #matching a document inserted on the last test.
    not_found = %{"q" => "unexistent_entity"}
     
    {:ok, results} = EntityRepository.search_entity(founded)
    
    assert {:ok, []} = EntityRepository.search_entity(not_found)
    assert  !Enum.empty?(results) 
  end
end    

