defmodule TimeManager.ChartManager do

  import Ecto.Query, warn: false
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Clocks.Clock
  alias TimeManager.Repo
  alias TimeManager.Users
  alias TimeManager.Users.User

  def get_all(startTime, endTime) do
    query = from(u in User, where: not is_nil(u.manager_id), distinct: u.manager_id, select: u.manager_id)
    distinct_manager_ids = Repo.all(query)
    all_team_members =
      distinct_manager_ids
      |> Enum.flat_map(&get_team(startTime, endTime, &1))

    all_team_members
  end

  def get_team(startTime, endTime, manager_id) do
    user = Users.get_user!(manager_id)
    for(team_id <- user.managed_teams, do: get_team_members(team_id, startTime, endTime, manager_id))
  end

  defp get_team_members(team_id, startTime, endTime, manager_id) do
    wt_query =
      from(wt in WorkingTime, where: wt.start >= ^startTime and wt.end <= ^endTime )
    c_query =
      from(c in Clock, where: c.start >= ^startTime and c.end <= ^endTime )

    query =
      from(u in User, where: u.manager_id == ^manager_id and u.teams_id == ^team_id, preload: [workingtimes: ^wt_query], preload: [clocks: ^c_query])

    Repo.all(query)
  end

end
