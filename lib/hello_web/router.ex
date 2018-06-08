defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    """
    Example routes
    @see [routes docs](https://hexdocs.pm/phoenix/Phoenix.Router.html#resources/4)
    """
    resources "/users", UsersController
    resources "/posts", PostController, only: [:index, :show]
    resources "/comments", CommentController, except: [:delete]

    """
    Example of forwarding through a specific pipeline. In this example, all of
    the following routes would first go through an authentication routine, and
    then an authorization routine (_signed in? also an admin?_ ...).
    """
    pipe_through [:authenticate_user, :ensure_admin]

    """
    Example forwarding all background jobs (requests to "/jobs") to a specific
    module (in this case, `BackgroundJob`)
    Additionally, options are passed through the 3rd argument. In this case, 
    a `name` parameter is set, which is presumably used by the given module.
    @see [options list](https://hexdocs.pm/phoenix/Phoenix.Router.html#scope/2)
    """
    forward "/jobs", BackgroundJob.Plug, name: "Hello Phoenix"
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end
end
