defmodule TimeManagerWeb.JWTAuthPlug do
  import Plug.Conn
  alias TimeManager.Users
  alias TimeManager.Users.User

  def init(opts), do: opts

  def call(conn, _) do
    bearer = Plug.Conn.get_req_header(conn,  "authorization") |> List.first()
    if bearer == nil do
      conn |> put_status(403)
    else
      token = bearer |> String.split(" ") |> List.last()
      signer = Joken.Signer.create("HS256", "NmM2Hu2tANjmiA2PeEugci8VbyXsvO6ObEFryrkbpoBycc6N9IJT7NHdo16bBGx3")

      {:ok, claims} = TimeManagerWeb.JWTToken.verify_and_validate(token, signer)
      IO.inspect(claims.exp)

      with {:ok, %{"user_id" => user_id, "exp" => exp}} <- TimeManagerWeb.JWTToken.verify_and_validate(token, signer), %User{} = user <- Users.get_user(user_id) do
        if valid_expiration?(exp) do
          conn |> assign(:current_user, user)
        else
          conn |> put_status(403) |> halt()
        end
      else
        {:error, _reason} -> conn |> put_status(403)
        _ -> conn |> put_status(403)
      end
    end
  end

  defp valid_expiration?(exp) do
    now = System.system_time(:seconds)
    exp > now
  end
end
