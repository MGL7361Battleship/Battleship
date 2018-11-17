defmodule BattleshipWeb.GameModelTest do
  use ExUnit.Case
  import Battleship.Game.Model

  test "Déterminer si la case est vide" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_bateau = "sous-marin"
    position = "A1"

    assert position_est_vide(structure, id_joueur, position)
    structure = modifier_orientation_bateau(structure, id_joueur, nom_bateau)
    structure = modifier_position_bateau(structure, id_joueur, nom_bateau, position)
    assert !position_est_vide(structure, id_joueur, "A1")
    assert !position_est_vide(structure, id_joueur, "A2")
    assert !position_est_vide(structure, id_joueur, "A3")
    assert position_est_vide(structure, id_joueur, "A4")
    structure = modifier_orientation_bateau(structure, id_joueur, nom_bateau)
    assert !position_est_vide(structure, id_joueur, "A1")
    assert !position_est_vide(structure, id_joueur, "B1")
    assert !position_est_vide(structure, id_joueur, "C1")
    assert position_est_vide(structure, id_joueur, "A2")
    assert position_est_vide(structure, id_joueur, "A3")

  end

  test "Obtenir toutes les positions d'un bateau" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_bateau = "sous-marin"

    assert get_all_positions_bateau(structure, id_joueur, nom_bateau) == []
    structure = modifier_orientation_bateau(structure, id_joueur, nom_bateau)
    assert get_all_positions_bateau(structure, id_joueur, nom_bateau) == []

    structure = modifier_position_bateau(structure, id_joueur, nom_bateau, "B2")
    assert get_all_positions_bateau(structure, id_joueur, nom_bateau) == ["B2", "B3", "B4"]
    structure = modifier_orientation_bateau(structure, id_joueur, nom_bateau)
    assert get_all_positions_bateau(structure, id_joueur, nom_bateau) == ["B2", "C2", "D2"]

  end

  test "Modifier la position d'un bateau sans validation" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nouv_s = modifier_position_bateau(structure, id_joueur, "torpilleur", "A3")
    assert Enum.at(nouv_s["torpilleur"], id_joueur)["position"] == "A3"
  end

  test "Modifier l'orientation d'un bateau sans validation" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nouv_s = modifier_orientation_bateau(structure, id_joueur, "torpilleur")
    assert Enum.at(nouv_s["torpilleur"], id_joueur)["orientation"] == "horizontal"
    nouv_s = modifier_orientation_bateau(nouv_s, id_joueur, "torpilleur")
    assert Enum.at(nouv_s["torpilleur"], id_joueur)["orientation"] == "vertical"
  end

  test "Changer le nom d'un joueur" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_joueur = "Nouveau nom joueur"
    nouv_s = changer_nom_joueur(structure, id_joueur, nom_joueur)
    assert Enum.at(nouv_s["monde"]["joueur"], id_joueur) == nom_joueur
  end

  test "Positionner un bateau" do
    {:ok, structure} = read_initial_state()
    nom_bateau = "torpilleur"
    position = "A1"
    id_joueur = 0
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == position
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == orientation
  end

  test "Positionner deux bateaux sur une même case" do
    {:ok, structure} = read_initial_state()
    nom_bateau = "torpilleur"
    position = "C3"
    id_joueur = 0
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)

    nom_bateau = "porte-avion"
    position = "A3"
    orientation = "vertical"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)
    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == ""
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == ""

  end

  test "Positionner un bateau déjà placé" do
    {:ok, structure} = read_initial_state()
    nom_bateau = "torpilleur"
    position = "A1"
    id_joueur = 0
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == position
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == orientation

    position = "B5"
    orientation = "vertical"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == position
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == orientation

  end

  test "Enlever un bateau" do
    {:ok, structure} = read_initial_state()
    nom_bateau = "torpilleur"
    position = "A1"
    id_joueur = 0
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == position
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == orientation

    structure = enlever_bateau(structure, id_joueur, nom_bateau)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == ""
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == ""

  end

  test "Faire la rotation d'un bateau" do
    {:ok, structure} = read_initial_state()
    nom_bateau = "torpilleur"
    position = "A1"
    id_joueur = 0
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)
    structure = rotation_bateau(structure, id_joueur, nom_bateau)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == "A1"
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == "vertical"

  end

  test "Faire la rotation d'un bateau impossible" do
    {:ok, structure} = read_initial_state()
    nom_bateau = "torpilleur"
    position = "B1"
    id_joueur = 0
    orientation = "horizontal"
    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)

    nom_bateau = "sous-marin"
    position = "A1"
    structure = positionner_bateau(structure, id_joueur, nom_bateau, position, orientation)


    structure = rotation_bateau(structure, id_joueur, nom_bateau)

    assert Enum.at(structure[nom_bateau], id_joueur)["position"] == position
    assert Enum.at(structure[nom_bateau], id_joueur)["orientation"] == "horizontal"

  end

  test "Attaquer une position vide" do
    {:ok, structure} = read_initial_state()
    position = "B1"
    id_joueur_attaquant = 0
    id_joueur_attaque = 1
    {true, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, position)

    j1_cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaquant)
    j1_cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaquant)

    j2_cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaque)
    j2_cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaque)

    assert length(j1_cases_manquees) == 1
    assert length(j2_cases_manquees) == 0
    assert length(j1_cases_touchees) == 0
    assert length(j2_cases_touchees) == 0

  end

  test "Attaquer une position occupée" do
    {:ok, structure} = read_initial_state()
    position = "B1"
    orientation = "horizontal"
    id_joueur_attaquant = 0
    id_joueur_attaque = 1

    structure = positionner_bateau(structure, id_joueur_attaque, "torpilleur", position, orientation)
    {true, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, position)
    {true, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, "B2")

    j1_cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaquant)
    j1_cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaquant)

    j2_cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaque)
    j2_cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaque)

    assert length(j1_cases_manquees) == 0
    assert length(j2_cases_manquees) == 0
    assert length(j1_cases_touchees) == 2
    assert length(j2_cases_touchees) == 0

  end

  test "Attaquer deux fois la même position" do
    {:ok, structure} = read_initial_state()
    position = "B1"
    orientation = "horizontal"
    id_joueur_attaquant = 0
    id_joueur_attaque = 1

    structure = positionner_bateau(structure, id_joueur_attaque, "torpilleur", position, orientation)
    {true, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, position)
    {false, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, position)

    {true, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, "D5")
    {false, structure} = attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, "D5")

    j1_cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaquant)
    j1_cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaquant)

    j2_cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaque)
    j2_cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaque)

    assert length(j1_cases_manquees) == 1
    assert length(j2_cases_manquees) == 0
    assert length(j1_cases_touchees) == 1
    assert length(j2_cases_touchees) == 0

  end

  test "Déterminer si la partie est terminée" do
    {:ok, structure} = read_initial_state()

    structure = positionner_bateau(structure, 1, "torpilleur", "A1", "horizontal")
    structure = positionner_bateau(structure, 1, "contre-torpilleur", "B1", "horizontal")
    structure = positionner_bateau(structure, 1, "sous-marin", "C1", "horizontal")
    structure = positionner_bateau(structure, 1, "porte-avion", "D1", "horizontal")
    structure = positionner_bateau(structure, 1, "croiseur", "E1", "horizontal")

    # "torpilleur" -> 2
    {true, structure} = attaquer_position(structure, 0, 1, "A1")
    {true, structure} = attaquer_position(structure, 0, 1, "A2")

    # "contre-torpilleur" -> 3
    {true, structure} = attaquer_position(structure, 0, 1, "B1")
    {true, structure} = attaquer_position(structure, 0, 1, "B2")
    {true, structure} = attaquer_position(structure, 0, 1, "B3")

    # "sous-marin" -> 3
    {true, structure} = attaquer_position(structure, 0, 1, "C1")
    {true, structure} = attaquer_position(structure, 0, 1, "C2")
    {true, structure} = attaquer_position(structure, 0, 1, "C3")

    # "porte-avion" -> 5
    {true, structure} = attaquer_position(structure, 0, 1, "D1")
    {true, structure} = attaquer_position(structure, 0, 1, "D2")
    {true, structure} = attaquer_position(structure, 0, 1, "D3")
    {true, structure} = attaquer_position(structure, 0, 1, "D4")
    {true, structure} = attaquer_position(structure, 0, 1, "D5")

    # "croiseur" -> 4
    {true, structure} = attaquer_position(structure, 0, 1, "E1")
    {true, structure} = attaquer_position(structure, 0, 1, "E2")
    {true, structure} = attaquer_position(structure, 0, 1, "E3")
    assert determiner_joueur_gagnant(structure, 0) == false
    {true, structure} = attaquer_position(structure, 0, 1, "E4")

    assert determiner_joueur_gagnant(structure, 0) == true
    assert determiner_joueur_gagnant(structure, 1) == false

  end

  test "Obtenir l'état d'un bateau" do
    {:ok, structure} = read_initial_state()

    nom_bateau = "porte-avion"
    id_joueur = 0
    id_joueur_adverse = 1
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur_adverse, nom_bateau, "A1", orientation)
    assert obtenir_etat_cases_bateau(structure, id_joueur_adverse, id_joueur, nom_bateau) == ["Intact", "Intact", "Intact", "Intact", "Intact"]

    {true, structure} = attaquer_position(structure, id_joueur, id_joueur_adverse, "A1")
    assert obtenir_etat_cases_bateau(structure, id_joueur_adverse, id_joueur, nom_bateau) == ["Touché", "Intact", "Intact", "Intact", "Intact"]

    {true, structure} = attaquer_position(structure, id_joueur, id_joueur_adverse, "A4")
    assert obtenir_etat_cases_bateau(structure, id_joueur_adverse, id_joueur, nom_bateau) == ["Touché", "Intact", "Intact", "Touché", "Intact"]

  end

  test "Obtenir l'état d'une partie" do
    {:ok, structure} = read_initial_state()

    nom_bateau = "torpilleur"
    id_joueur = 0
    id_joueur_adverse = 1
    orientation = "horizontal"

    structure = positionner_bateau(structure, id_joueur, nom_bateau, "A1", orientation)
    {true, structure} = attaquer_position(structure, id_joueur_adverse, id_joueur, "A1")
    {true, structure} = attaquer_position(structure, id_joueur, id_joueur_adverse, "C1")

    etat = obtenir_etat_partie(structure, id_joueur, id_joueur_adverse)
    assert etat == %{
      "cases_manquees" => ["C1"],
      "cases_touchees" => [],
      "contre-torpilleur" => %{},
      "croiseur" => %{},
      "porte-avion" => %{},
      "sous-marin" => %{},
      "torpilleur" => %{"A1" => "Touché", "A2" => "Intact"}
    }

  end

end
