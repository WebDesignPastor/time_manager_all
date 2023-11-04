defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  #def sign_in(conn, %{"email" => email, "password" => password}) do
  #  case Users.get_by_email(email) do
  #    %User{} = user -> 
  #      case Bcrypt.verify_pass(password, user.password) do
  #        true ->
  #          render(conn, :index, user: user)
  #        false -> 
  #          render(conn, :error, message: "Incorrect password")
  #      end
  #    _ -> render(conn, :error, message: "User not found") 
  #  end
  #end

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    case Users.get_by_id(id) do 
      { :ok, %User{} = user } -> render(conn, :references_show, user: user)
      _ -> render(conn, :error, message: "User not found")
    end
  end

  def show(conn, %{"username" => username, "email" => email}) do
    user = Users.get_by(username, email)
    render(conn, :show, user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
