defmodule TimeManager.ChartManager do

  import Ecto.Query, warn: false
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Repo
  alias TimeManager.Users.User


  def get_all(teams, startTime, endTime) do
    test = get_team_members(teams, startTime, endTime)
    {:ok, test}
  end

  defp get_team_members(teams, startTime, endTime) do
      query =
      from(u in User, where: fragment("? @> ?::integer[]", u.teams_id, ^teams))
      Repo.all(query)
    
  end

end
