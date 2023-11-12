defmodule TimeManagerWeb.JWTAuthPlug do
  import Plug.Conn
  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManager.TokenBlacklist
  alias TimeManager.JwtBlacklist

  def init(opts), do: opts

  def call(conn, _) do
    bearer = Plug.Conn.get_req_header(conn,  "authorization") |> List.first()
    if bearer == nil do
      conn |> put_status(403)
    else
      token = bearer |> String.split(" ") |> List.last()
      case TokenBlacklist.token_blacklisted?(token) do
        %JwtBlacklist{} -> conn |> put_status(403) |> send_resp(:unauthorized, "Token is blacklisted") |> halt()
        nil -> conn
      end

      key = System.get_env("SECRET_KEY_BASE")
      signer = Joken.Signer.create("HS256", key)

      with {:ok, %{"user_id" => user_id, "exp" => exp}} <- TimeManagerWeb.JWTToken.verify_and_validate(token, signer), %User{} = user <- Users.get_user(user_id) do
        if valid_expiration?(exp) do
          conn |> assign(:current_user, user)
        else
          TokenBlacklist.add_to_blacklist(token)
          conn |> put_status(403) |> send_resp(:unauthorized, "Token expired") |> halt()
        end
      else
        {:error, _reason} -> conn |> put_status(403)
        _ -> conn |> put_status(403)
      end
    end
  end

  defp valid_expiration?(exp) do
    now = System.system_time(:second)
    exp > now
  end
end
