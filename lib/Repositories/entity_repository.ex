defmodule Repositories.EntityRepository do
  require Logger
  @elastic_url "http://localhost:9200"


  def create_index do
    Logger.info "Creating a new index."
    IO.inspect Elastix.Index.create("http://elasticsearch:9200", "entities", %{})
    
  end
  
  def mapping do
    mapping = %{
      properties: %{
        title: %{type: "text"},
        type:  %{type: "keyword"},
      },
    }  
    
    Elastix.Mapping.put(@elastic_url, "entities", "entity", mapping)
  end

  def index_entity do 
    # Example of data.
    entity_data = %{
      title: "Some title",
      type: "TOPIC",
    }
    
    Elastix.Document.index_new(@elastic_url, "entities", "entity", entity_data)
  end

  def search_entity(query \\ %{}),
    do: Elastix.Search.search(@elastic_url, "entities", ["entity"], query)  

  def delete_entity(_id),
    do: Elastix.Document.delete(@elastic_url, "entities", "entity", _id)
end
