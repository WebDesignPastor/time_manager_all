defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManagerWeb.JWTToken

  action_fallback TimeManagerWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Users.get_by_email(email) do
      {:ok, %User{} = user} -> 
        case Bcrypt.verify_pass(password, user.password) do
          true ->
            csrf_token = get_session(conn, :csrf_token)
            if csrf_token do
              IO.inspect("csrf found")
            else
              IO.inspect("csrf not found creating it")
              csrf_token = Plug.CSRFProtection.get_csrf_token()
              conn = put_session(conn, :csrf_token, csrf_token)
            end

            signer = Joken.Signer.create("HS256", "NmM2Hu2tANjmiA2PeEugci8VbyXsvO6ObEFryrkbpoBycc6N9IJT7NHdo16bBGx3")
            extra_claims = %{
              "user_id" => user.id,
              "csrf_token" => csrf_token,
              "exp" => System.system_time(:second) + 30 * 24 * 60 * 60
            }
            {:ok, token, _claims} = JWTToken.generate_and_sign(extra_claims, signer)
            render(conn, :auth, user: user, token: token)
          false -> 
            render(conn, :error, message: "Incorrect password")
        end
      _ -> render(conn, :error, message: "User not found") 
    end
  end

  def sign_out(conn, _params) do
    render(conn, :error, message: "sign_out not working")
  end
end 
