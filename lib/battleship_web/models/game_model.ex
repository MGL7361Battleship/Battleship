defmodule Battleship.Game do

  @doc """
  Read a JSON file and returns its content
  """
  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  @doc """
  Return the initial state of the application
  """
  def read_initial_state() do
    get_json("lib/battleship_web/models/initial_state.json")
  end

  @doc """
  Receives the name of the player and return it's index to access other related data
  """
  def obtenir_index_joueur(structure, nom_joueur) do
    Enum.find_index(structure["monde"]["joueur"], &(&1 == nom_joueur))
  end

  @doc """
  Change the state of a cell on the grid with a new state.
  """
  def update_etat_case(structure, id_joueur, nom_bateau, position_case, nouveau_statut) do
    bateau_a_modifier = Enum.at(structure[nom_bateau], id_joueur)
    etat_cases = bateau_a_modifier["etat_cases"]
    nouvel_etat_cases = List.replace_at(etat_cases, position_case, nouveau_statut)
    nouveau_bateau = put_in(bateau_a_modifier["etat_cases"], nouvel_etat_cases)
    put_in(structure[nom_bateau], List.replace_at(structure[nom_bateau], id_joueur, nouveau_bateau))
  end

  @doc """
  Change the name of a player
  """
  def changer_nom_joueur(structure, id_joueur, nom_joueur) do
    nouveaux_joueurs = List.replace_at structure["monde"]["joueur"], id_joueur, nom_joueur
    put_in structure["monde"]["joueur"], nouveaux_joueurs
  end

  @doc """
  Change the orientation of a boat.
  No validation is being done.
  """
  def modifier_orientation_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)

    cond do
      bateau["orientation"] == "horizontal" -> modifier_orientation_bateau(structure, id_joueur, nom_bateau, "vertical")
      bateau["orientation"] == "vertical" -> modifier_orientation_bateau(structure, id_joueur, nom_bateau, "horizontal")
      bateau["orientation"] == "" -> modifier_orientation_bateau(structure, id_joueur, nom_bateau, "horizontal")
    end
  end

  def modifier_orientation_bateau(structure, id_joueur, nom_bateau, orientation) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["orientation"], orientation
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  @doc """
  Get the name of the boats.
  """
  def obtenir_noms_bateaux() do
    ["torpilleur", "contre-torpilleur", "sous-marin", "porte-avion", "croiseur"]
  end

  def obtenir_nb_cases(nom_bateau) do
    case nom_bateau do
      "torpilleur" -> 2
      "contre-torpilleur" -> 3
      "sous-marin" -> 3
      "porte-avion" -> 5
      "croiseur" -> 4
    end
  end

    @doc """
  If no orientation is provided, return an empty list
  """
  def calculer_positions(_, _, "") do
    []
  end

    @doc """
  If no position is provided, return an empty list
  """
  def calculer_positions("", _, _) do
    []
  end

  @doc """
  receives a position and how many cells in the grid we want
  returns a list of positions including the one received in parameter

  Example: calculer_positions_horizontales("A1", 3)
  Returns ["A1", "A2", "A3"]
  """
  def calculer_positions(position, nb_cases, "horizontal") do
    prochaine_position_horizontale = fn(count) ->
      position_lettre = String.first(position)
      position_chiffre = String.to_integer(String.last(position))
      nouvelle_position_chiffre = to_string(position_chiffre + count)

      Enum.join([position_lettre, nouvelle_position_chiffre])
    end

    Enum.map(0..nb_cases-1, prochaine_position_horizontale)
  end

  @doc """
  Same as the horizontal function
  """
  def calculer_positions(position, nb_cases, "vertical") do
    prochaine_position_verticale = fn(count) ->
      position_lettre = List.first(to_charlist(position))
      position_chiffre = String.last(position)
      nouvelle_position_lettre = to_string([position_lettre + count])

      Enum.join([nouvelle_position_lettre, position_chiffre])
    end

    Enum.map(0..nb_cases-1, prochaine_position_verticale)
  end

  @doc """
  get all the positions of a boat that is placed on the grid.
  """
  def get_all_positions_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    nb_cases = obtenir_nb_cases(nom_bateau)
    position = bateau["position"]

    calculer_positions(position, nb_cases, bateau["orientation"])
  end

  @doc """
  Check if there is a boat placed on a position on the grid.
  """
  def position_est_vide(structure, id_joueur, position) do
    bateaux = obtenir_noms_bateaux()
    positions = Enum.flat_map(bateaux, &(get_all_positions_bateau(structure, id_joueur, &1)))
    Enum.all?(positions, &(&1 != position))
  end

  @doc """
  Modify the position of a boat.
  No validation is being done beforehand.
  """
  def modifier_position_bateau(structure, id_joueur, nom_bateau, position) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], position
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  @doc """
  Place a boat on the grid.
  Will not work if a position is occupied.
  """
  def positionner_bateau(structure, id_joueur, nom_bateau, position, orientation) do
    nb_cases = obtenir_nb_cases(nom_bateau)
    nouvelles_positions_bateau = calculer_positions(position, nb_cases, orientation)

    positions_vides = Enum.map(nouvelles_positions_bateau, &(position_est_vide(structure, id_joueur, &1)))

    if Enum.all?(positions_vides) do
      structure = modifier_position_bateau(structure, id_joueur, nom_bateau, position)
      modifier_orientation_bateau(structure, id_joueur, nom_bateau, orientation)
    else
      structure
    end
  end

  @doc """

  """
  def enlever_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], ""
    bateau = put_in bateau["orientation"], ""
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  @doc """

  """
  def rotation_bateau(structure, id_joueur, nom_bateau) do

  end

  @doc """

  """
  def attaquer_position(structure, id_joueur, position) do

  end

end
