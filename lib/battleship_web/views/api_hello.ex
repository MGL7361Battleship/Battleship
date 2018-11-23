defmodule BattleshipWeb.ApiView do
  def render("api_hello.json", %{"email" => email, "password" => password}) do
    %{
      data: %{
        user: %{
          id: "123455",
          email: email,
          password: password
        }
      }
    }
  end
end
