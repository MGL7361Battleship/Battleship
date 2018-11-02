defmodule BattleshipWeb.GameModelTest do
  use ExUnit.Case
  import Battleship.Game

  test "Changer le nom d'un joueur" do
    {:ok, structure} = read_initial_state()
    id_joueur = 0
    nom_joueur = "Joueur 1"
    nouv_s = changer_nom_joueur(structure, id_joueur, nom_joueur)
    assert Enum.at(nouv_s["monde"]["joueurs"], id_joueur) == nom_joueur
  end

  test "Change l'état d'une case" do
    {:ok, structure} = read_initial_state()
    nom_joueur = "Joueur 1"
    nom_bateau = "torpilleurs"
    position_case = 1
    nouveau_statut = "Modifié"
    id_joueur = 0
    structure = changer_nom_joueur(structure, id_joueur, nom_joueur)

    new_state = update_etat_case(structure, nom_joueur, nom_bateau, position_case, nouveau_statut)
    bateau_modifie = Enum.at new_state[nom_bateau], id_joueur
    assert Enum.at(bateau_modifie["etat_cases"], position_case) == nouveau_statut
  end
end
