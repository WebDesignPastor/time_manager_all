defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.FallbackController

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => id, "start" => startTime, "end" => endTime}) do
    time = WorkingTimes.get_by(id, startTime, endTime)
    render(conn, :index, workingtimes: time)
  end

  #currently send an empty array if no working time might need to change this
  def index(conn, %{"userID" => id}) do
    working_times = WorkingTimes.list_user_workingtimes(id)
    case working_times do
      {:error, :workingtime_not_found} ->
        conn |> put_status(:not_found) |> render(:error, message: "Workingtime not found")
      {:error, :user_not_found} ->
        conn |> put_status(:not_found) |> render(:error, message: "User not found")
      {:ok, working_times} ->
        render(conn, :index, workingtimes: working_times)
    end
  end


  def show(conn, %{"userID" => user_id, "id" => id}) do
    workingtime = WorkingTimes.get_one(user_id, id)
    render(conn, :index, workingtimes: workingtime)
  end

  # def show(conn, %{"userID" => user_id, "id" => id}) do
  #   case WorkingTimes.get_one(user_id, id) do
  #     %WorkingTime{} = workingtime ->
  #       conn
  #       |> put_status(:ok)
  #       |> render(:index, workingtimes: workingtime)
  #     _ ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> render(:error, message: "couldn't find workingtime")
  #   end
  # end

  def create(conn, %{"userID" => id, "start" => startTime, "end" => endTime}) do
    id = String.to_integer(id)
    working_time_params = %{start: startTime, end: endTime}

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(id, working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:index, workingtimes: working_time)
    end
  end

  def update(conn, %{"id" => id, "start" => startTime, "end" => endTime}) do
    working_time = WorkingTimes.get_working_time!(id)
    working_time_params = %{start: startTime, end: endTime}

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :index, workingtimes: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
