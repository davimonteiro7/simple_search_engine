defmodule SimpleSearchEngine.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)
  
  post "/search-engine/entities" do
    {:ok, body, conn} = read_body(conn)
    
    body = Poison.decode!(body)
    
    IO.inspect(body)
    
    send_resp(conn, 200, "Into the route.")
  end

  get "/" do     
    send_resp(conn, 200, "Backend Container - root router")
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end
