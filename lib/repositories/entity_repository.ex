defmodule Repositories.EntityRepository do
  require Logger
  
  @elastic_url "http://localhost:9200"
  @index "entities"
  @type_ "entity"
    
  def exist_index?(index \\ @index), do: Elastix.Index.exists?(@elastic_url, index) 
  
  def create_index do 
    Logger.info "Creating a new index..."  
    
    response =  Elastix.Index.create(@elastic_url, @index, %{})
    case response do
      {:ok, _}    ->  handle_index_creation(response)
      {:error, _} ->  throw_error_message()
    end    
  end
  
  def index_entity(entity_data) do 
    Logger.info "Indexing a new entity..."
    response = Elastix.Document.index_new(@elastic_url, @index, @type_, entity_data)
    case response do
      {:ok, _}    ->  handle_index_insertion(response)
      {:error, _} ->  throw_error_message()   
    end
  end

  def search_entity(query) do
    Logger.info "Searching an entity at elastic instance..."
    response = Elastix.Search.search(@elastic_url, @index, [@type_], handle_query(query))
    case response do
      {:ok, _}    ->  handle_search_result(response)
      {:error, _} ->  throw_error_message()   
    end
  end

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

  defp throw_error_message, 
    do: {:error, "Please, check your connection with elasticsearch."}

  defp handle_index_creation({:ok, response}) when response.status_code === 400,
    do: {:ok, :already_exists}

  defp handle_index_creation({:ok, response}) when response.status_code === 201,
    do: {:ok, :created} 

  defp handle_index_insertion({:ok, response}),   
    do: {:ok, response.status_code}
       
  defp handle_search_result({:ok, response}), 
    do: {:ok, response.body["hits"]["hits"]}
end
