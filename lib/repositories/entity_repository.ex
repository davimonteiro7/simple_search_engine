defmodule Repositories.EntityRepository do
  require Logger
  
  @elastic_url "http://localhost:9200"
  @index "entities"
  @type_ "entity"
  
  handle_result = fn
                  {:ok, 201}      -> {:ok, "successfully created"}
                  {:ok, result}   -> {:ok, result.body["hits"]["hits"]}
                  {:error, _}     -> {:error, "server error, please check your elastic instance."} 
                  end 


  # example of output: {:ok, true}, {;ok, false}, {:error, _}
  def exist_index?(index \\ @index), do: Elastix.Index.exists?(@elastic_url, index) 
  
  def create_index do 
    Logger.info "Creating a new index..."  
    {flag_return, response} = Elastix.Index.create(@elastic_url, @index, %{})
    {flag_return, response.status}
      |> handle_result
  end
  
  def mapping(map_of_data) do
    Elastix.Mapping.put(@elastic_url, @index, @type_, map_of_data, [include_type_name: true])
  end

  def index_entity(entity_data) do 
    Logger.info "Indexing a new entity..."
    {flag_return, response } = Elastix.Document.index_new(@elastic_url, @index, @type_, entity_data)
    {flag_return, response.status_code} 
      |> handle_result
  end

  def search_entity(query) do
    Logger.info "Searching an entity..."
    {flag_return, response} = Elastix.Search.search(@elastic_url, @index, [@type_], parse_query(query))  
     
      |> handle_result
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
