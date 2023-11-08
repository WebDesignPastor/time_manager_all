defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :auth do
    plug TimeManagerWeb.JWTAuthPlug
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth]
    # commented to remove csrf protection
    # pipe_through [:api, :csrf]

    resources "/users", UserController, param: "userID", except: [:edit]
    post "/users/logout", AuthController, :logout 
  
    resources "/workingtimes/:userID", WorkingTimeController, only: [:index, :create, :show]
    resources "/workingtimes", WorkingTimeController, only: [:delete, :update]

    get "/clocks/:userID", ClockController, :clock

    post "/chartmanager", ChartManagerController, :show
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api
    
    post "/users/:userID", UserController, :new
    post "/users/login", AuthController, :login, as: :login
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
