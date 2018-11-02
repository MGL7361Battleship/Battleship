defmodule BattleshipWeb.GameModelTest do
  use ExUnit.Case
  import Battleship.Game

  test "Obtenir toutes les positions d'un bateau" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_joueur = "Joueur 1"
    nom_bateau = "sous-marin"
    structure = modifier_position_bateau(structure, nom_joueur, nom_bateau, "B2")

    # assert get_all_positions_bateau(structure, nom_joueur, nom_bateau) == ["B2", "C2", "D2"]
    assert get_all_positions_bateau(structure, nom_joueur, nom_bateau) == ["B2", "B3", "B4"]

  end

  test "Modifier la position d'un bateau sans validation" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_joueur = "Joueur 1"
    nouv_s = modifier_position_bateau(structure, nom_joueur, "torpilleur", "A3")
    assert Enum.at(nouv_s["torpilleur"], id_joueur)["position"] == "A3"
  end

  test "Modifier l'orientation d'un bateau sans validation" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_joueur = "Joueur 1"
    nouv_s = modifier_orientation_bateau(structure, nom_joueur, "torpilleur")
    assert Enum.at(nouv_s["torpilleur"], id_joueur)["orientation"] == "horizontal"
    nouv_s = modifier_orientation_bateau(nouv_s, nom_joueur, "torpilleur")
    assert Enum.at(nouv_s["torpilleur"], id_joueur)["orientation"] == "vertical"
  end

  test "Changer le nom d'un joueur" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_joueur = "Nouveau nom joueur"
    nouv_s = changer_nom_joueur(structure, id_joueur, nom_joueur)
    assert Enum.at(nouv_s["monde"]["joueur"], id_joueur) == nom_joueur
  end

  test "Change l'état d'une case" do
    {:ok, structure} = read_initial_state()
    nom_joueur = "Joueur 1"
    nom_bateau = "torpilleur"
    position_case = 1
    nouveau_statut = "Modifié"
    id_joueur = 0

    new_state = update_etat_case(structure, nom_joueur, nom_bateau, position_case, nouveau_statut)
    bateau_modifie = Enum.at new_state[nom_bateau], id_joueur
    assert Enum.at(bateau_modifie["etat_cases"], position_case) == nouveau_statut
  end

  test "Positionner un bateau" do

  end

  test "Positionner deux bateaux sur une même case" do

  end

  test "Positionner un bateau déjà placé" do

  end

  test "Ajouter un bateau sur la grille n'importe où" do

  end

  test "Enlever un bateau" do

  end

  test "Faire la rotation d'un bateau" do

  end

  test "Faire la rotation d'un bateau impossible" do

  end

  test "Attaquer une position vide" do

  end

  test "Attaquer une position occupée" do

  end

  test "Attaquer deux fois la même position" do

  end

end
