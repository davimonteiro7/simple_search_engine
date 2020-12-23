defmodule SimpleSearchEngine.Application do
  
  use Application
  alias SimpleSearchEngine.Router
  
  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: SimpleSearchEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
