defmodule TimeManager.ChartManager do

  import Ecto.Query, warn: false
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Clocks.Clock
  alias TimeManager.Repo
  alias TimeManager.Users.User

  def get_all(startTime, endTime) do
    query = from(u in User, where: not is_nil(u.manager_id), distinct: u.manager_id, select: u.manager_id)
    distinct_manager_ids = Repo.all(query)
    get_team(distinct_manager_ids, startTime, endTime)
  end

  def get_team(teams, startTime, endTime) do
      for(team_id <- teams, do: get_team_members(team_id, startTime, endTime))
  end

  defp get_team_members(team_id, startTime, endTime) do
    wt_query =
      from(wt in WorkingTime, where: wt.start >= ^startTime and wt.end <= ^endTime )
    c_query =
      from(c in Clock, where: c.start >= ^startTime and c.end <= ^endTime )
    query =
      from(u in User, where: u.manager_id == ^team_id, preload: [workingtimes: ^wt_query], preload: [clocks: ^c_query])
    Repo.all(query)
  end

end
