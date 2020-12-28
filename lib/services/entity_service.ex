defmodule Services.EntityService do
  alias Repositories.EntityRepository 
  require Logger

  def create_entity(body_data) do
    Logger.info "Decoding an entity..."
    entity_data = Poison.decode!(body_data)
    check_index()

    EntityRepository.index_entity(entity_data) 
      |> format_results()   
  end

  def find_entity(parameter) do 
    EntityRepository.search_entity(parameter)
      |> format_results()
  end
  
  defp check_index do
    case EntityRepository.exist_index?() do
      {:ok, true}  -> {:ok, :already_exists} 
      {:ok, false} -> EntityRepository.create_index()
    end
  end
  
  
  defp format_results({:ok, 201}),
    do: {:ok, :created, "Successffuy created.\n"}
  
  defp format_results({:ok, []}),  
    do: {:error, :client, "Not found an entity with these parameters."}
    
  defp format_results({:error, message}), 
    do: {:error, :server, message}
    
  defp format_results({:ok, results}) do 
    results = results 
      |> Enum.map(fn entity -> entity["_source"] |> Map.put_new("_id", entity["_id"]) end)
      |> Poison.encode!()    
    {:ok, results}
  end
end
