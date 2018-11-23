
defmodule BattleshipWeb.ApiController do
  use BattleshipWeb, :controller

  def testaaa(conn, %{"user" => %{"email" => email, "password" => password}}) do
    render conn, "api_hello.json", %{"email" => email, "password" => password}
  end
end
