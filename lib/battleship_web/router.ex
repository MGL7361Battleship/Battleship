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

  # Other scopes may use custom stacks.
  scope "/api", BattleshipWeb do
    pipe_through :api
    post "/changer_nom_joueur", ApiController, :changer_nom_joueur
    post "/positionner_bateau", ApiController, :positionner_bateau
    post "/enlever_bateau", ApiController, :enlever_bateau
    post "/rotation_bateau", ApiController, :rotation_bateau
    post "/attaquer_position", ApiController, :attaquer_position
    post "/obtenir_etat_partie", ApiController, :obtenir_etat_partie
    post "/determiner_joueur_gagnant", ApiController, :determiner_joueur_gagnant
    get "/view_state", ApiController, :view_state
  end

  scope "/", BattleshipWeb do
    pipe_through :browser # Use the default browser stack
    get "/hello/:name", HelloController, :world
    get "/", PageController, :index
  end

end
