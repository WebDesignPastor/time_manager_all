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
      wt_query =
      from(c in Clock, where: wt.start >= ^startTime and wt.end <= ^endTime )
      c_query =
      from(wt in WorkingTime, where: c.start >= ^startTime and c.end <= ^endTime )
      query =
      from(u in User, where: fragment("? @> ?::integer[]", u.teams_id, ^teams), preload: [workingtimes: ^wt_query], preload: [clocks: ^c_query])
      Repo.all(query)
    
  end

end
