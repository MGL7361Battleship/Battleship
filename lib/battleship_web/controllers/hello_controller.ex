defmodule BattleshipWeb.HelloController do
  use BattleshipWeb, :controller

  def world(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
end
