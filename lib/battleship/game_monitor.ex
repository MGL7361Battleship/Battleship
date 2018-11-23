
defmodule Battleship.Game.Monitor do
  alias Battleship.Game.Model

  def start_link() do
    {:ok, initial_state} = Model.read_initial_state()
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def changer_nom_joueur(id_joueur, nom_joueur) do
    Agent.update(__MODULE__, fn state -> Model.changer_nom_joueur(state, id_joueur, nom_joueur) end)
  end

  def positionner_bateau(id_joueur, nom_bateau, position, orientation) do
    Agent.update(__MODULE__, fn state -> Model.positionner_bateau(state, id_joueur, nom_bateau, position, orientation) end)
  end

  def enlever_bateau(id_joueur, nom_bateau) do
    Agent.update(__MODULE__, fn state -> Model.enlever_bateau(state, id_joueur, nom_bateau) end)
  end

  def rotation_bateau(id_joueur, nom_bateau) do
    Agent.update(__MODULE__, fn state -> Model.rotation_bateau(state, id_joueur, nom_bateau) end)
  end

  def attaquer_position(id_joueur_attaquant, id_joueur_attaque, position) do
    Agent.update(__MODULE__, fn state ->
      {true, state} = Model.attaquer_position(state, id_joueur_attaquant, id_joueur_attaque, position)
      state
    end)
  end

  def obtenir_etat_partie(id_joueur, id_joueur_adverse) do
    Agent.get(__MODULE__, fn state -> Model.obtenir_etat_partie(state, id_joueur, id_joueur_adverse) end)
  end

  def view_state() do
    Agent.get(__MODULE__, fn state -> state end)
  end

end
