defmodule Services.EntityService do
  alias Repositories.EntityRepository 
  require Logger

  def create_entity(body_data) do
    Logger.info "Decoding an entity..."
    entity_data = Poison.decode!(body_data)
    check_index()
    EntityRepository.index_entity(entity_data) 
  end

  def find_entity(parameter), 
    do: EntityRepository.search_entity(parameter)
    
  defp check_index do
    case EntityRepository.exist_index?() do
      {:ok, true}  -> {:ok, :already_exists} 
      {:ok, false} -> EntityRepository.create_index()
    end
  end
end
