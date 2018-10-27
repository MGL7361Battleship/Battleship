defmodule BattleshipWeb.Router do
  use BattleshipWeb, :router

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

  scope "/", BattleshipWeb do
    pipe_through :browser # Use the default browser stack
    get "/hello/:name", HelloController, :world
    get "/", PageController, :index
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Battleship"
      }
    }
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :battleship, swagger_file: "swagger.json"
  end

  # Other scopes may use custom stacks.
  # scope "/api", BattleshipWeb do
  #   pipe_through :api
  # end
end
