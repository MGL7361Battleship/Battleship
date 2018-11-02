defmodule Battleship.Game do

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  def read_initial_state() do
    get_json("lib/battleship_web/models/initial_state.json")
  end

  def obtenir_index_joueur(structure, nom_joueur) do
    Enum.find_index(structure["monde"]["joueur"], &(&1 == nom_joueur))
  end

  def update_etat_case(structure, nom_joueur, nom_bateau, position_case, nouveau_statut) do
    id_joueur = obtenir_index_joueur(structure, nom_joueur)
    bateau_a_modifier = Enum.at(structure[nom_bateau], id_joueur)
    etat_cases = bateau_a_modifier["etat_cases"]
    nouvel_etat_cases = List.replace_at(etat_cases, position_case, nouveau_statut)
    nouveau_bateau = put_in(bateau_a_modifier["etat_cases"], nouvel_etat_cases)
    put_in(structure[nom_bateau], List.replace_at(structure[nom_bateau], id_joueur, nouveau_bateau))
  end

  def changer_nom_joueur(structure, id_joueur, nom_joueur) do
    nouveaux_joueurs = List.replace_at structure["monde"]["joueur"], id_joueur, nom_joueur
    put_in structure["monde"]["joueur"], nouveaux_joueurs
  end

  def modifier_orientation_bateau(structure, nom_joueur, nom_bateau) do
    id_joueur = obtenir_index_joueur(structure, nom_joueur)
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    if bateau["orientation"] == "horizontal" do
      bateau = put_in bateau["orientation"], "vertical"
      bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
      put_in structure[nom_bateau], bateaux
      else
      bateau = put_in bateau["orientation"], "horizontal"
      bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
      put_in structure[nom_bateau], bateaux
      end
  end

  def obtenir_noms_bateaux() do
    ["torpilleur", "contre-torpilleur", "sous-marin", "porte-avion", "croiseur"]
  end

  def get_all_positions_bateau(structure, nom_joueur, nom_bateau) do
    id_joueur = obtenir_index_joueur(structure, nom_joueur)
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    nb_cases = bateau["nb_cases"]
    position = bateau["position"]

    if bateau["orientation"] == "vertical" do
      # letters
      Enum.map(0..nb_cases-1, &(Enum.join([to_string([List.first(to_charlist(position))+&1]), String.last(position)])))
    else
      # numbers
      Enum.map(0..nb_cases-1, &(Enum.join([String.first(position), to_string(String.to_integer(String.last(position)) + &1)])))
    end
  end

  def position_est_vide(structure, nom_joueur, position) do
    id_joueur = obtenir_index_joueur(structure, nom_joueur)

  end

  def modifier_position_bateau(structure, nom_joueur, nom_bateau, position) do
    id_joueur = obtenir_index_joueur(structure, nom_joueur)
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], position
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  def positionner_bateau(structure, nom_joueur, nom_bateau, position) do
    id_joueur = obtenir_index_joueur(structure, nom_joueur)
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], position

  end

  def ajouter_bateau(structure, nom_joueur, nom_bateau) do

  end

  def enlever_bateau(structure, nom_joueur, nom_bateau) do

  end

  def rotation_bateau(structure, nom_joueur, nom_bateau) do

  end

  def attaquer_position(structure, nom_joueur, position) do

  end

end
