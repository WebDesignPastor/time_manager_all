defmodule TimeManagerWeb.ChartManagerController do
  use TimeManagerWeb, :controller

  alias TimeManager.ChartManager

  plug :can_show when action in [:show]

  defp can_show(conn, _opts) do
    if conn.status == 403 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]

    case {conn.params["userID"]} do
      {_requested_user_id} when current_user.role == "general_manager" or current_user.role == "manager" -> conn
      _ -> conn |> put_status(:unauthorized) |> render(:error, message: "Not authorized based on role")
    end
  end

  def show(conn, %{"start" => startTime, "end" => endTime}) do
    current_user = conn.assigns[:current_user]

    case current_user.role do
      "manager" -> 
        teams = ChartManager.get_team(current_user.managed_teams, startTime, endTime)
        render(conn, :references_show, teams: teams)
      "general_manager" -> 
        teams = ChartManager.get_all(startTime, endTime)
        render(conn, :references_show, teams: teams)
    end
  end
end
