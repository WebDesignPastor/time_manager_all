defmodule TimeManagerWeb.ChartManagerController do
  use TimeManagerWeb, :controller

  alias TimeManager.ChartManager
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  plug :can_show when action in [:show]

  defp can_show(conn, _opts) do
    if conn.status == 403 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]

    case {conn.params["userID"]} do
      {requested_user_id} when current_user.role == "general_manager" or current_user.role == "manager" -> conn
      _ -> render(conn, :error, message: "Not authorized based on role")
    end
  end

  def show(conn, %{"teams" => teams, "start" => startTime, "end" => endTime}) do
    #current_user = conn.assigns[:current_user]



    

    #case current_user.role do
    #  "manager" -> 
    #    IO.inspect("manager")
    #    teams = ChartManager.get_all(current_user.teams_managed, startTime, endTime)
    #    render(conn, :references_show, teams: teams)
    #  "general_manager" -> 
    #    IO.inspect("general manager")
    #    test = ChartManager.test()
    #end
    
    teams = ChartManager.get_all(teams, startTime, endTime)
    case teams do
      teams -> render(conn, :references_show, teams: teams)
      _ -> render(conn, :error, message: "error")
    end
  end
end
