
defmodule BattleshipWeb.ApiController do
  use BattleshipWeb, :controller
  alias Battleship.Game.Monitor

  def changer_nom_joueur(conn, %{"id_joueur" => id_joueur, "nom_joueur" => nom_joueur}) do
    Monitor.changer_nom_joueur(id_joueur, nom_joueur)
    render conn, "api_status.json", %{"status" => :ok}
  end

  def positionner_bateau(conn, %{"id_joueur" => id_joueur, "nom_bateau" => nom_bateau, "position" => position, "orientation" =>  orientation}) do
    Monitor.positionner_bateau(id_joueur, nom_bateau, position, orientation)
    render conn, "api_status.json", %{"status" => :ok}
  end

  def enlever_bateau(conn, %{"id_joueur" => id_joueur, "nom_bateau" => nom_bateau}) do
    Monitor.enlever_bateau(id_joueur, nom_bateau)
    render conn, "api_status.json", %{"status" => :ok}
  end

  def rotation_bateau(conn, %{"id_joueur" => id_joueur, "nom_bateau" => nom_bateau}) do
    Monitor.rotation_bateau(id_joueur, nom_bateau)
    render conn, "api_status.json", %{"status" => :ok}
  end

  def attaquer_position(conn, %{"id_joueur_attaquant" => id_joueur_attaquant, "id_joueur_attaque" => id_joueur_attaque, "position" => position}) do
    Monitor.attaquer_position(id_joueur_attaquant, id_joueur_attaque, position)
    render conn, "api_status.json", %{"status" => :ok}
  end

  def obtenir_etat_partie(conn, %{"id_joueur" => id_joueur, "id_joueur_adverse" => id_joueur_adverse}) do
    state = Monitor.obtenir_etat_partie(id_joueur, id_joueur_adverse)
    render conn, "api_game_status.json",  state
  end

  def view_state(conn, _params) do
    state = Monitor.view_state()
    render conn, "api_view_state.json",  %{"state" => state}
  end

end
