defmodule Repositories.EntityRepository do
  require Logger
  @elastic_url "http://localhost:9200"

  def create_index do
    Logger.info "Checking an index..."
    {connection, check} = Elastix.Index.exists?(@elastic_url, "entities")
    
    if check do
      Logger.info "That index already exists!"
      {connection, :already_exists}
    else
      Logger.info "Creating a new index..."  
      {connection, response} = Elastix.Index.create(@elastic_url, "entities", %{})
      {connection, response.status_code}
    end 
  end
  
  def mapping(map_of_data) do
    Elastix.Mapping.put(@elastic_url, "entities", "entity", map_of_data, [include_type_name: true])
  end

  def index_entity(entity_data) do 
    Logger.info "Indexing a new entity..."
    {instanced, response } = Elastix.Document.index_new(@elastic_url, "entities", "entity", entity_data)
    {instanced, response.status_code}
  end

  def search_entity(query) do
    Logger.info "Searching an entity..."
    Elastix.Search.search(@elastic_url, "entities", ["entity"], parse_query(query))  
  end

  def remove_entity_by_id(id),
    do: Elastix.Document.delete(@elastic_url, "entities", "entity", id)
  
  defp parse_query(query) do
    %{
      query: %{
        match: %{
          title: %{ query: query, operator: "and", fuzziness: "auto"}
        }
      }
    }
  end
end
