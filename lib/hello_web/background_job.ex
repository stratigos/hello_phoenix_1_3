"""
Demo background job / worker process. This coincides with the "Routing: Foward"
section of the Hello Phoenix tutorial. 
@see [routing: forward](https://hexdocs.pm/phoenix/routing.html#forward)
"""

defmodule HelloWeb.BackgroundJob.Plug do
  def init(opts), do: opts
  def call(conn, opts) do
    conn
    |> Plug.Conn.assign(:name, Keyword.get(opts, :name, "Background Job"))
    |> HelloWeb.BackgroundJob.Router.call(opts)
  end
end

defmodule HelloWeb.BackgroundJob.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Welcome to #{conn.assigns.name}")
  get "/active", do: send_resp(conn, 200, "5 Active Jobs")
  get "/pending", do: send_resp(conn, 200, "3 Pending Jobs")
  match _, do: send_resp(conn, 404, "Not found")
end
