defmodule TimeManagerWeb.JWTAuthPlug do
  import Plug.Conn
  alias TimeManager.Users
  alias TimeManager.Users.User

  def init(opts), do: opts

  def call(conn, _) do
    bearer = Plug.Conn.get_req_header(conn,  "authorization") |> List.first()
    if bearer == nil do
      conn |> put_status(401)
    else
      token = bearer |> String.split(" ") |> List.last()
      signer = Joken.Signer.create("HS256", "NmM2Hu2tANjmiA2PeEugci8VbyXsvO6ObEFryrkbpoBycc6N9IJT7NHdo16bBGx3")

      with {:ok, %{"user_id" => user_id}} <- TimeManagerWeb.JWTToken.verify_and_validate(token, signer), %User{} = user <- Users.get_user(user_id) do
        conn |> assign(:current_user, user)
      else
        {:error, _reason} -> conn |> put_status(401)
        _ -> conn |> put_status(401)
      end
    end
  end
end
