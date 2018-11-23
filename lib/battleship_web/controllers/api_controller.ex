
defmodule BattleshipWeb.ApiController do
  use BattleshipWeb, :controller

  def changer_nom_joueur(conn, %{"id_joueur" => id_joueur, "nom_joueur" => nom_joueur}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

  def positionner_bateau(conn, %{"id_joueur" => id_joueur, "nom_bateau" => nom_bateau, "position" => position, "orientation" =>  orientation}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

  def enlever_bateau(conn, %{"id_joueur" => id_joueur, "nom_bateau" => nom_bateau}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

  def rotation_bateau(conn, %{"id_joueur" => id_joueur, "nom_bateau" => nom_bateau}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

  def attaquer_position(conn, %{"id_joueur_attaquant" => id_joueur_attaquant, "id_joueur_attaque" => id_joueur_attaque, "position" => position}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

  def determiner_joueur_gagnant(conn, %{"id_joueur" => id_joueur}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

  def obtenir_etat_partie(conn, %{"id_joueur" => id_joueur, "id_joueur_adverse" => id_joueur_adverse}) do

    render conn, "api_status.json", %{"status" => :ok}
  end

end
