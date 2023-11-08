defmodule TimeManager.ChartManager do

  import Ecto.Query, warn: false
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Clocks.Clock
  alias TimeManager.Repo
  alias TimeManager.Users.User


  def get_all(teams, startTime, endTime) do
      for(team <- teams, do: get_team_members(team, startTime, endTime))
  end

  defp get_team_members(team, startTime, endTime) do
       wt_query =
       from(wt in WorkingTime, where: wt.start >= ^startTime and wt.end <= ^endTime )
       c_query =
       from(c in Clock, where: c.start >= ^startTime and c.end <= ^endTime )
       query =
       from(u in User, where: u.teams_id == ^team, preload: [workingtimes: ^wt_query], preload: [clocks: ^c_query])
      Repo.all(query)
  end

  #defp get_all_teams(startTime, endtime) do
  #  wt_query =
  #    from(wt in WorkingTime, where: wt.start >= ^startTime and wt.end <= ^endTime )
  #  c_query =
  #    from(c in Clock, where: c.start >= ^startTime and c.end <= ^endTime )
  #  query =
  #    from(u in User, where: u.teams_id == ^team, preload: [workingtimes: ^wt_query], preload: [clocks: ^c_query])
  #  Repo.all(query)
  #end

  #def test() do
  #  query = from(u in User, where: not is_nil(u.manager_id), distinct: u.manager_id)
  #  distinct_manager_ids = Repo.all(query)
  #  IO.inspect(distinct_manager_ids)
  #end
end
