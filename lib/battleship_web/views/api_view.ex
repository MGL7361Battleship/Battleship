defmodule BattleshipWeb.ApiView do
  def render("api_status.json", %{"status" => status}) do
    %{status: status}
  end
end
