defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  plug :is_general_manager when action in [:index]
  plug :can_update when action in [:update, :show, :delete]

  defp can_update(conn, _opts) do
    if conn.status == 401 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]

    case {conn.params["userID"]} do
      {requested_user_id} ->
        case Users.get_user(requested_user_id) do
          %User{} when current_user.role == "general_manager" ->
            conn
          %User{} = requested_user when current_user.id == requested_user.id ->
            conn
          %User{} = requested_user when current_user.role == "manager" and requested_user.manager_id == current_user.id ->
            conn
          nil -> conn |> put_status(:bad_request) |> render(:error, message: "Incorrect userId in request")|> halt()
          _ -> conn |> put_status(:unauthorized) |> render(:error, message: "Not authorized based on role") |> halt()
        end
    end
  end

  defp is_general_manager(conn, _opts) do
    if conn.status == 401 do render(conn, :error, message: "Not authorized") end

    case conn.assigns[:current_user] do
      %User{role: "general_manager"} -> conn
      %User{role: "manager"} -> conn
      _ -> conn |> put_status(:unauthorized) |> render(:error, message: "not allowed") |> halt()
    end
  end

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = 
    if current_user.role != "general_manager" do
      Users.list_users_from_team(current_user.id)
    else
      Users.list_users()
    end
    render(conn, :index, users: users)
  end

  # error messages already set with constraint error / may need to edit it's formating
  def create(conn, %{"username" => username, "email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Users.create_user(username, email, password) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    else
      _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "coulnd't create user") |> halt()
    end
  end

  def show(conn, %{"userID" => id}) do
    case Users.get_by_id(id) do
      { :ok, %User{} = user } -> conn |> put_status(:ok) |> render(:references_show, user: user)
      _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "Couldn't fetch user data")
    end
  end

  #def show(conn, %{"username" => username, "email" => email}) do
  #  user = Users.get_by(username, email)
  #  render(conn, :show, user: user)
  #end

  def update(conn, %{"userID" => id} = user_params) do
    user = Users.get_user!(id)
    current_user_role = conn.assigns.current_user.role 

    user_params =
    if user_params["manager_id"] != user.manager_id do
      Map.put(user_params, "teams_id", 0)
    else
      user_params
    end

    user_params =
    case user_params["role"] do
      #demotion
      "employee" when user.role == "manager" -> 
        Map.put(user_params, "managed_teams", nil)
      #promotion
      "manager" when user.role == "employee" ->
        user_params 
        |> Map.put("manager_id", nil)
        |> Map.put("teams_id", 0)
      _ -> user_params
    end

    allowed_fields =
      case current_user_role do
        "manager" when conn.assigns.current_user.id == user.id ->
          ["email", "username", "password", "teams_id", "managed_teams"]
        "manager" ->
          ["email", "username", "password", "teams_id"]
        "general_manager" ->
          ["email", "username", "password", "teams_id", "manager_id", "managed_teams", "role"]
        _ ->
          ["email", "username", "password"]
      end

    filtered_params = Map.take(user_params, allowed_fields)

    with {:ok, %User{} = user} <- Users.update_user(user, filtered_params) do
      conn |> put_status(:ok) |> render(:full_user_show, user: user)
    else
      _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "couldn't update user") |> halt()
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Users.get_user!(id)

    if user.role == "manager" do
      case Users.delete_user(user) do
        {:ok, %User{}} -> 
          Users.update_users(user.id)
          send_resp(conn, :no_content, "")
        _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "couln't delete user")
      end
    else
      with {:ok, %User{}} <- Users.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    end

  end
end
