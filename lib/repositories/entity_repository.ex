defmodule Repositories.EntityRepository do
  require Logger
  
  @elastic_url "http://localhost:9200"
  @index "entities"
  @type_ "entity"
  
   
  # example of output: {:ok, true}, {;ok, false}, {:error, _}
  def exist_index?(index \\ @index), do: Elastix.Index.exists?(@elastic_url, index) 
  
  def create_index do 
    Logger.info "Creating a new index..."  
    Elastix.Index.create(@elastic_url, @index, %{}) 
  end
  
  def mapping(map_of_data) do
    Elastix.Mapping.put(@elastic_url, @index, @type_, map_of_data, [include_type_name: true])
  end

  def index_entity(entity_data) do 
    Logger.info "Indexing a new entity..."
    Elastix.Document.index_new(@elastic_url, @index, @type_, entity_data)
      |> handle_index_result()    
  end

  def search_entity(query) do
    Logger.info "Searching an entity..."
    Elastix.Search.search(@elastic_url, @index, [@type_], handle_query(query))
      |> handle_search_result()
  end

  def remove_entity_by_id(id),
    do: Elastix.Document.delete(@elastic_url, "entities", "entity", id)
  
  defp handle_query(query) do
    %{
      size: 100,
      query: %{
        match: %{
          title: %{ query: query, operator: "and", fuzziness: "auto"}
        }
      }
    }
  end
  
  defp handle_index_result({:error, _}),  
    do: {:error, "Please, check your connection with elasticsearch."}
   
  defp handle_index_result({:ok, response}),   
    do: {:ok, response.status_code}
    
  defp handle_search_result({:error, _}), 
    do: {:error, "Please, check your connection with elasticsearch."}
    
  defp handle_search_result({:ok, response}), 
    do: {:ok, response.body["hits"]["hits"]}

end
