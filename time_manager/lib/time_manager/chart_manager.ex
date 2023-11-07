defmodule TimeManager.ChartManager do

  import Ecto.Query, warn: false
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Clocks.Clock
  alias TimeManager.Repo
  alias TimeManager.Users.User


  def get_all(teams, startTime, endTime) do
    test = get_team_members(teams, startTime, endTime)
  end

  defp get_team_members(teams, startTime, endTime) do
       wt_query =
       from(wt in WorkingTime, where: wt.start >= ^startTime and wt.end <= ^endTime )
       c_query =
       from(c in Clock, where: c.start >= ^startTime and c.end <= ^endTime )
    query =
       from(u in User, where: fragment("? = ANY(?)", u.teams_id, ^teams), preload: [workingtimes: ^wt_query], preload: [clocks: ^c_query])
      Repo.all(query)
  end

end
