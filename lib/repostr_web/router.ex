defmodule RepostrWeb.Router do
  use RepostrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RepostrWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug :fetch_session
  end

  scope "/", RepostrWeb do
    pipe_through :browser

    live "/", HomeLive
    get "/logout", NostrAuthController, :logout
  end

  scope "/api", RepostrWeb.Api do
    pipe_through :api

    scope "/v1", V1 do
      post "/nostr/auth", NostrAuthController, :login
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", RepostrWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:repostr, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RepostrWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
