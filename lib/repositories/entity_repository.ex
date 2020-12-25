defmodule Repositories.EntityRepository do
  require Logger
  @elastic_url "http://elasticsearch:9200"

  def create_index do
    {connection, check} = Elastix.Index.exists?(@elastic_url, "entities")
    
    if check do
      {connection, :already_exists}
    else
      {connection, response} = Elastix.Index.create(@elastic_url, "entities", %{})
      {connection, response.status_code}
    end 
  end
  
  def mapping(map_of_data) do
    Elastix.Mapping.put(@elastic_url, "entities", "entity", map_of_data, [include_type_name: true])
  end

  def index_entity(entity_data) do 
    Elastix.Document.index_new(@elastic_url, "entities", "entity", entity_data)
  end

  def search_entity(query \\ %{}),
    do: Elastix.Search.search(@elastic_url, "entities", ["entity"], query)  

  def remove_entity_by_id(id),
    do: Elastix.Document.delete(@elastic_url, "entities", "entity", id)
end
