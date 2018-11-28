defmodule BattleshipWeb.ApiView do
  def render("api_status.json", %{"status" => status}) do
    %{status: status}
  end

  def render("api_game_status.json", %{"state" => state}) do
    %{state: state}
  end

  def render("api_view_state.json", %{"state" => state}) do
    %{state: state}
  end

  def render("api_winning_player.json", %{"joueur_est_gagnant" => joueur_est_gagnant}) do
    %{joueur_est_gagnant: joueur_est_gagnant}
  end

end
