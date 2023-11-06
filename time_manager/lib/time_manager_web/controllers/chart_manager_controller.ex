defmodule TimeManagerWeb.ChartManagerController do
  use TimeManagerWeb, :controller

  alias TimeManager.ChartManager
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  def show(conn, %{"teams" => teams, "start" => startTime, "end" => endTime}) do
    users = ChartManager.get_all(teams, startTime, endTime)
    IO.inspect(users)
    case users do
      {:ok, [_] = user} -> render(conn, :show, users: user)
      _ -> render(conn, :error, message: "error")
    end

  end

end
