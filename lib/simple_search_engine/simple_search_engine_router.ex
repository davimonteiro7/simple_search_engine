defmodule SimpleSearchEngine.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  
  alias Repositories.EntityRepository

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do    
    
    send_resp(conn, 200, "Backend Container - root router")
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end
