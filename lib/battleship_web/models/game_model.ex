defmodule Battleship.Game do

  @doc """
  Lis un fichier JSON et retourne son contenu.
  """
  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  @doc """
  Retourne l'état initial de l'application.
  """
  def read_initial_state() do
    get_json("lib/battleship_web/models/initial_state.json")
  end

  @doc """
  Reçois le nom du joueur et retroune son indexe pour accéder aux autres données associées.
  """
  def obtenir_index_joueur(structure, nom_joueur) do
    Enum.find_index(structure["monde"]["joueur"], &(&1 == nom_joueur))
  end

  @doc """
  Change le nom du joueur.
  """
  def changer_nom_joueur(structure, id_joueur, nom_joueur) do
    nouveaux_joueurs = List.replace_at structure["monde"]["joueur"], id_joueur, nom_joueur
    put_in structure["monde"]["joueur"], nouveaux_joueurs
  end

  @doc """
  Change l'orientatin du bateau.
  Aucune validation n'est faite.
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
  Obtenir le nom des bateaux.
  """
  def obtenir_noms_bateaux() do
    [
      "torpilleur",
      "contre-torpilleur",
      "sous-marin",
      "porte-avion",
      "croiseur"
    ]
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
  Si aucune orientation n'est donnée, retourne une liste vide.
  """
  def calculer_positions(_, _, "") do
    []
  end

    @doc """
  Si aucune orientation n'est donnée, retourne une liste vide.
  """
  def calculer_positions("", _, _) do
    []
  end

  @doc """
  Reçois une position et le nombre de cases que nous voulons dans la grille.
  Retourne une liste des positions incluant celle reçue en paramètre.

  Exemple: calculer_positions_horizontales("A1", 3)
  Retourne ["A1", "A2", "A3"]
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
  Même fonctionnalités que la fonction horizontale.
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
  Obtenir toutes les positions d'un bateau sur la grille.
  """
  def get_all_positions_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    nb_cases = obtenir_nb_cases(nom_bateau)
    position = bateau["position"]

    calculer_positions(position, nb_cases, bateau["orientation"])
  end

  @doc """
  Vérifie si il y a un bateau placé à une position sur la grille.
  """
  def position_est_vide(structure, id_joueur, position, nom_bateau_a_positionner) do
    bateaux = obtenir_noms_bateaux()
    positions = Enum.flat_map(bateaux, &(if nom_bateau_a_positionner != &1, do: get_all_positions_bateau(structure, id_joueur, &1), else: []))
    Enum.all?(positions, &(&1 != position))
  end

  def position_est_vide(structure, id_joueur, position) do
    position_est_vide(structure, id_joueur, position, "")
  end

  @doc """
  Modifie la position d'un bateau.
  Aucune validation n'est faite au préalable.
  """
  def modifier_position_bateau(structure, id_joueur, nom_bateau, position) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], position
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  @doc """
  Place un bateau sur la grille.
  Ne fonctionnera pas si une position est occupée par un autre bateau.
  """
  def positionner_bateau(structure, id_joueur, nom_bateau, position, orientation) do
    nb_cases = obtenir_nb_cases(nom_bateau)
    nouvelles_positions_bateau = calculer_positions(position, nb_cases, orientation)

    positions_vides = Enum.map(nouvelles_positions_bateau, &(position_est_vide(structure, id_joueur, &1, nom_bateau)))

    if Enum.all?(positions_vides) do
      structure = modifier_position_bateau(structure, id_joueur, nom_bateau, position)
      modifier_orientation_bateau(structure, id_joueur, nom_bateau, orientation)
    else
      structure
    end
  end

  @doc """
    Retire un bateau de la grille.
  """
  def enlever_bateau(structure, id_joueur, nom_bateau) do
    bateau = Enum.at(structure[nom_bateau], id_joueur)
    bateau = put_in bateau["position"], ""
    bateau = put_in bateau["orientation"], ""
    bateaux = List.replace_at structure[nom_bateau], id_joueur, bateau
    put_in structure[nom_bateau], bateaux
  end

  @doc """
    Modifie l'orientation d'un bateau:
      de horizontal à vertical ou
      de vertical à horizontal.
  """
  def rotation_bateau(structure, id_joueur, nom_bateau) do
    nb_cases = obtenir_nb_cases(nom_bateau)
    bateau = Enum.at(structure[nom_bateau], id_joueur)

    trouver_nouvelle_orientation = fn() ->
      case bateau["orientation"] do
        "horizontal" -> "vertical"
        "vertical" -> "horizontal"
      end
    end
    nouvelle_orientation = trouver_nouvelle_orientation.()
    nouvelles_positions_bateau = calculer_positions(bateau["position"], nb_cases, nouvelle_orientation)
    positions_vides = Enum.map(nouvelles_positions_bateau, &(position_est_vide(structure, id_joueur, &1, nom_bateau)))

    if Enum.all?(positions_vides) do
      modifier_orientation_bateau(structure, id_joueur, nom_bateau)
    else
      structure
    end

  end

  @doc """
  Attaque une position
  Si la position adverse est occupée, la position se retrouve dans les cases_touchees
  Si la position est vide, la position se retrouve dans les cases_manquees
  Si la position a déjà été attaquée, rien n'est changé
  """
  def attaquer_position(structure, id_joueur_attaquant, id_joueur_attaque, position) do

    verifier_deja_attaque = fn() ->
      cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaquant)
      cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaquant)
      cases = cases_manquees ++ cases_touchees
      Enum.any?(cases, &(position == &1))
    end
    deja_attaque = verifier_deja_attaque.()
    position_vide = position_est_vide(structure, id_joueur_attaque, position)

    ajouter_position_touchees = fn() ->
      cases_touchees = Enum.at(structure["case_touchees"], id_joueur_attaquant)
      cases_touchees = cases_touchees ++ [position]
      nouvelles_cases_touchees = List.replace_at structure["case_touchees"], id_joueur_attaquant, cases_touchees
      put_in structure["case_touchees"], nouvelles_cases_touchees
    end

    ajouter_position_manquees = fn() ->
      cases_manquees = Enum.at(structure["case_manquees"], id_joueur_attaquant)
      cases_manquees = cases_manquees ++ [position]
      nouvelles_cases_manquees = List.replace_at structure["case_manquees"], id_joueur_attaquant, cases_manquees
      put_in structure["case_manquees"], nouvelles_cases_manquees
    end

    cond do
      deja_attaque -> {false, structure}
      position_vide -> {true, ajouter_position_manquees.()}
      !position_vide -> {true, ajouter_position_touchees.()}
    end

  end

  @doc """
  La partie est terminée lorsque le nombre de cases touchées est égal au nombre de cases de bateaux du joueur adverse
  """
  def determiner_joueur_gagnant(structure, id_joueur) do
    cases_touchees = Enum.at(structure["case_touchees"], id_joueur)
    nb_cases_touchees = length(cases_touchees)
    noms_bateaux = obtenir_noms_bateaux()
    nb_cases_bateaux = Enum.sum(Enum.map(noms_bateaux, &(obtenir_nb_cases(&1))))
    nb_cases_touchees == nb_cases_bateaux
  end

  @doc """
  Obtenir l'état des cases d'un bateau donné
  """
  def obtenir_etat_cases_bateau(structure, id_joueur, id_joueur_adverse, nom_bateau) do
    cases_touchees = Enum.at(structure["case_touchees"], id_joueur)
    positions = get_all_positions_bateau(structure, id_joueur_adverse, nom_bateau)
    Enum.map(positions, &(if Enum.member?(cases_touchees, &1), do: "Touché", else: "Intact"))
  end

end
