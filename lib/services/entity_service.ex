defmodule Services.EntityService do
  alias Repositories.EntityRepository 
  require Logger

  def create_entity(body_data) do
    Logger.info "Decoding an entity..."
    entity_data = Poison.decode!(body_data)
    check_index()
    EntityRepository.index_entity(entity_data) 
  end

  def find_entity(parameter) do
    {connection, response } = EntityRepository.search_entity(parameter)
    results = response.body["hits"]["hits"]
  end 
  
  defp check_index, do: EntityRepository.create_index()
end
