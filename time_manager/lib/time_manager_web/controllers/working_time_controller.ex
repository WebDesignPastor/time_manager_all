defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Users.User
  alias TimeManager.Users

  plug :can_index when action in [:index]
  plug :can_update_delete_create when action in [:update, :delete, :create]

  defp can_index(conn, _opts) do
    if conn.status == 403 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]

    case {conn.params["userID"]} do
      {_requested_user_id} when current_user.role == "general_manager" ->
        conn
      {requested_user_id} ->
        case Users.get_user(requested_user_id) do
          %User{} = requested_user when current_user.id == requested_user.id ->
            conn
          %User{} = requested_user when current_user.role == "manager" and requested_user.manager_id == current_user.id ->
            conn
          nil -> render(conn, :error, message: "Incorrect userId in request")
          _ -> render(conn, :error, message: "Not authorized based on role")
        end
    end
  end

  # {if employee = false, elsif general_manager = true else{ if current_user = manager and requested_user is in team of manager = true else false }}
  defp can_update_delete_create(conn, _opts) do
    if conn.status == 401 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]

    case {conn.params["userID"]} do
      {_requested_user_id} when current_user.role == "employee" ->
        render(conn, :error, message: "Not authorized")
      {_requested_user_id} when current_user.role == "general_manager" ->
        conn
      {requested_user_id} ->
        case Users.get_user(requested_user_id) do
          %User{} = requested_user when current_user.role == "manager" and requested_user.manager_id == current_user.id ->
            conn
          nil -> render(conn, :error, message: "Incorrect userId in request")
          _ -> render(conn, :error, message: "Not authorized based on role")
        end
    end
  end

  def index(conn, %{"userID" => id, "start" => startTime, "end" => endTime}) do
    case WorkingTimes.get_by(id, startTime, endTime) do
      nil -> conn |> put_status(:not_found) |> render(:error, message: "Workingtime not found")
      _ = working_times -> render(conn, :index, workingtimes: working_times)
    end
  end

  #def show(conn, %{"userID" => user_id, "id" => id}) do
  #  workingtime = WorkingTimes.get_one(user_id, id)
  #  render(conn, :index, workingtimes: workingtime)
  #end

  def create(conn, %{"userID" => id, "start" => startTime, "end" => endTime}) do
    id = String.to_integer(id)
    working_time_params = %{start: startTime, end: endTime}

    case WorkingTimes.create_working_time(id, working_time_params) do
      nil -> conn |> put_status(:internal_server_error) |> render(:error, message: "couldn't create working_time") 
      %Ecto.Changeset{} -> conn |> put_status(:unprocessable_entity) |> render(:error, message: "Invalid format")
      _ = working_time -> conn |> put_status(:created) |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}") |> render(:index, working_times: working_time)
    end
  end

  def update(conn, %{"id" => id, "start" => startTime, "end" => endTime}) do
    working_time = WorkingTimes.get_working_time(id)
    case working_time do
      nil ->
        conn |> put_status(:not_found) |> render("error.json", message: "Workingtime not found")
      {:ok, working_time} ->
        working_time_params = %{start: startTime, end: endTime}
        with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
          render(conn, :index, workingtimes: working_time)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time(id)
    case working_time do
      nil ->
        conn |> put_status(:not_found) |> render("error.json", message: "Workingtime not found")
      _ ->
        with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
          send_resp(conn, :no_content, "")
        end
    end
  end
end
