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
      {requested_user_id} when current_user.role == "general_manager" ->
        conn
      {requested_user_id} ->
        case Users.get_user(requested_user_id) do
          %User{} = requested_user when current_user.id == requested_user.id ->
            conn
          %User{} = requested_user when current_user.role == "manager" and requested_user.manager_id == current_user.id ->
            conn
          nil -> render(conn, :error, message: "Incorrect userId in request")
          _ -> render(conn, :error, message: "Not authorized base on role")
        end
    end
  end

  defp is_general_manager(conn, _opts) do
    if conn.status == 401 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]
    case conn.assigns[:current_user] do
      %User{role: "general_manager"} -> conn
      %User{role: "manager"} -> conn
      _ -> render(conn, :error, message: "not allowed")
    end
  end

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = 
    if current_user.role != "general_manager" do
      users = Users.list_users_from_team(current_user.id)
    else
      users = Users.list_users()
    end
    render(conn, :index, users: users)
  end

  # error messages already set with constraint error / may need to edit it's formating
  def create(conn, %{"username" => username, "email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Users.create_user(username, email, password) do
      IO.puts('test')
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

  #def show(conn, %{"username" => username, "email" => email}) do
  #  user = Users.get_by(username, email)
  #  render(conn, :show, user: user)
  #end

  def update(conn, %{"userID" => id} = user_params) do
    user = Users.get_user!(id)
    current_user_role = conn.assigns.current_user.role 
    user_params = user_params

    #user_params =
    #case user_params["role"] do
    #  #demotion
    #  "employee" when user.role == "manager" -> 
    #    user_params = Map.put(user_params, "managed_teams", nil)
    #    user_params = Map.put(user_params, "teams_id", 0)
    #  #promotion
    #  "manager" when user.role == "employee" ->
    #    user_params = Map.put(user_params, "manager_id", nil)
    #    user_params = Map.put(user_params, "teams_id", 0)
    #  _ -> user_params
    #end

    #problem because the manager_id is not set by the back here a manager can be set for a user with a different teams  
    allowed_fields =
      case current_user_role do
        "manager" ->
          allowed_fields = ["email", "username", "password", "teams_id"]
        "general_manager" ->
          allowed_fields = ["email", "username", "password", "teams_id", "manager_id", "managed_teams", "role"]
        _ ->
          allowed_fields = ["email", "username", "password"]
      end

    filtered_params = Map.take(user_params, allowed_fields)

    with {:ok, %User{} = user} <- Users.update_user(user, filtered_params) do
      render(conn, :full_user_show, user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
