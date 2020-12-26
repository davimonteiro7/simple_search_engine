defmodule SimpleSearchEngine.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  alias Services.EntityService

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)
  
  post "/search-engine/entities" do
    {:ok, body, conn} = read_body(conn)
     
    response = EntityService.create_entity(body)
    
    IO.inspect(response)
    
    send_resp(conn, 201, "Post route")
  end

  get "/search-engine/entities" do     
    params = fetch_query_params(conn)
    parameter = params.query_params["q"]

    {_, results} = EntityService.find_entity(parameter)
    
    IO.inspect(results)
    
    send_resp(conn, 200, "Backend Container - root router")
  end
     
  match _ do
    send_resp(conn, 404, "Page not found")
  end
end
