defmodule SimpleSearchEngine.EntityRepositoryTest do
  use ExUnit.Case
  alias Repositories.EntityRepository
  require Logger

  @map_entity  %{
    properties: %{
      title: %{type: "text"},
      type:  %{type: "keyword"},
    },
  }

  @sample_doc  %{
      title: "Some title",
      type: "TOPIC",
  }

  @query_test  %{
    query: %{ 
      match: %{ 
        title: %{ 
          query: "titl", 
          operator: "and", 
          fuzziness: "auto"} 
      }
    }     
  }
    
  test "Create a new index on Elasticsearch" do
    {connection, response} = EntityRepository.create_index()

    assert connection === :ok
    assert response === :already_exists or response === 201
  end

  test "Mapping a type to the index." do
    {connection, response} =  EntityRepository.mapping(@map_entity)
    
    assert connection === :ok
    assert response.status_code  ===  200
  end 
  
  test "Insert a new documemt to the index." do
    {connection, response} = EntityRepository.index_entity(@sample_doc)
       
    assert connection === :ok
    assert response.status_code === 201
  end

  test "Search a document into an index." do
    {connection, response} = EntityRepository.search_entity(@query_test)

    assert connection  === :ok
    assert response.status_code === 200 
  end
  
  test "Remove an existent document into an index" do
    {_, resp} = EntityRepository.search_entity(@query_test)
    existent_id = resp.body["hits"]["hits"] |> Enum.at(0) 
    existent_id = existent_id["_id"]
    
    {connection, response} = EntityRepository.remove_entity_by_id(existent_id) 
    
    assert {connection, response.status_code} === {:ok, 200} 
  end

end
