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

  def update_etat_case(structure, id_joueur, nom_bateau, position_case, nouveau_statut) do
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

  def modifier_orientation_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)

    changer_orientation = fn(orientation) ->
      bateau = put_in bateau["orientation"], orientation
      bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
      put_in structure[nom_bateau], bateaux
    end

    cond do
      bateau["orientation"] == "horizontal" -> changer_orientation.("vertical")
      bateau["orientation"] == "vertical" -> changer_orientation.("horizontal")
      bateau["orientation"] == "" -> changer_orientation.("horizontal")
    end
  end

  def obtenir_noms_bateaux() do
    ["torpilleur", "contre-torpilleur", "sous-marin", "porte-avion", "croiseur"]
  end

  def get_all_positions_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    nb_cases = bateau["nb_cases"]
    position = bateau["position"]

    prochaine_position_horizontale = fn(count) ->
      position_lettre = String.first(position)
      position_chiffre = String.to_integer(String.last(position))
      nouvelle_position_chiffre = to_string(position_chiffre + count)

      Enum.join([position_lettre, nouvelle_position_chiffre])
    end

    prochaine_position_verticale = fn(count) ->
      position_lettre = List.first(to_charlist(position))
      position_chiffre = String.last(position)
      nouvelle_position_lettre = to_string([position_lettre + count])

      Enum.join([nouvelle_position_lettre, position_chiffre])
    end

    calculer_positions = fn ->
      cond do
        bateau["orientation"] == "vertical" -> Enum.map(0..nb_cases-1, prochaine_position_verticale)
        bateau["orientation"] == "horizontal" -> Enum.map(0..nb_cases-1, prochaine_position_horizontale)
        bateau["orientation"] == "" -> []
      end
    end

    cond do
      position == "" -> []
      position != "" -> calculer_positions.()
    end
  end

  def position_est_vide(structure, id_joueur, position) do
    bateaux = obtenir_noms_bateaux()
    positions = Enum.flat_map(bateaux, &(get_all_positions_bateau(structure, id_joueur, &1)))
    Enum.all?(positions, &(&1 != position))
  end

  def modifier_position_bateau(structure, id_joueur, nom_bateau, position) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], position
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  def positionner_bateau(structure, id_joueur, nom_bateau, position) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], position

  end

  def ajouter_bateau(structure, id_joueur, nom_bateau) do

  end

  def enlever_bateau(structure, id_joueur, nom_bateau) do

  end

  def rotation_bateau(structure, id_joueur, nom_bateau) do

  end

  def attaquer_position(structure, id_joueur, position) do

  end

end
