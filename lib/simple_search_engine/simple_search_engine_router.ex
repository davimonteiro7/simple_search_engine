defmodule SimpleSearchEngine.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  alias Services.EntityService

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)
  
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]

  post "/search-engine/entities" do
    {:ok, body, conn} = read_body(conn)
     
    {status_code, message} = EntityService.create_entity(body) |> handle_response()
    
    send_resp(conn, status_code, message)
  end

  get "/search-engine/entities" do     
        
    parameter = fetch_query_params(conn).params["q"]
    
    params = fetch_query_params(conn).params
        
    {status_code, response} = EntityService.find_entity(params) |> handle_response()

    send_resp(conn, status_code, response)
  end
     
  match _ do
    send_resp(conn, 404, "Page not found")
  end

  defp handle_response(response) do
    case response do  
      {:ok, :founded, results}          ->  {200, results}
      {:ok, :created, message}          ->  {201, message}
      {:error, :not_founded, message}   ->  {404, message}
      {:error, :server_error, message}  ->  {500, message}
    end
  end
end
