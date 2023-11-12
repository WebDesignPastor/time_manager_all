defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManagerWeb.JWTToken
  alias TimeManager.TokenBlacklist

  action_fallback TimeManagerWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.get_by_email(email) do
      {:ok, %User{} = user} ->
        case Bcrypt.verify_pass(password, user.password) do
          true ->
            #csrf_token = get_session(conn, :csrf_token)
            #if csrf_token do
            #  IO.inspect("csrf found")
            #else
            #  IO.inspect("csrf not found creating it")
            #  csrf_token = Plug.CSRFProtection.get_csrf_token()
            #  conn = put_session(conn, :csrf_token, csrf_token)
            #end
            key = Application.get_env(:time_manager, TimeManagerWeb.Endpoint)[:secret_key_base]
            signer = Joken.Signer.create("HS256", key)
            extra_claims = %{
              "user_id" => user.id,
              #"csrf_token" => csrf_token,
              "exp" => System.system_time(:second) + 30 * 24 * 60 * 60
            }
            # generate token
            {:ok, token, _claims} = JWTToken.generate_and_sign(extra_claims, signer)
            # verify token
            #{:ok, _claims} = JWTToken.verify_and_validate(token, signer)

            conn |> put_status(:ok) |> render(:auth, user: user, token: token)
          false ->
            conn |> put_status(:unauthorized) |> render(:error, message: "Incorrect password")
        end
      _ -> conn |> put_status(:not_found) |> render(:error, message: "User not found")
    end
  end

  def logout(conn, _params) do
    bearer = Plug.Conn.get_req_header(conn,  "authorization") |> List.first()
    if bearer != nil do
      token = bearer |> String.split(" ") |> List.last()
      TokenBlacklist.add_to_blacklist(token)
      conn |> put_status(200) |> send_resp(:ok, "signed out")
    end
  end
end
