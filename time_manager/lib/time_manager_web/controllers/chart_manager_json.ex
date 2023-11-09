defmodule TimeManagerWeb.ChartManagerJSON do

  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock
  alias TimeManager.WorkingTimes.WorkingTime

  def error(%{message: message}) do
    %{error: message} 
  end

  def references_show(%{teams: teams}) do
    teams = for(team <- teams, do: print_team(team))
    %{
      teams: teams
    }
  end

  defp print_team(team) do
    case Enum.at(team, 0) do
      nil -> %{}
      _ = first_user -> 
        users = for(user <- team, do: print_user(user))
        %{
          teams_id: first_user.teams_id,
          users: users
        }
    end
  end

  defp print_user(user) do
    %{
    id: user.id,
    username: user.username,
    email: user.email,
    role: user.role,
    managerId: user.manager_id,
    teamsId: user.teams_id,
    managedTeams: user.managed_teams,
    workingTimes: workingtimes_data(user.workingtimes),
    clock: clocks_data(user.clocks) 
    }
  end

  defp workingtimes_data(workingtimes) do
      case workingtimes do
        nil -> nil
        _ -> for(workingtime <- workingtimes, do: %{start: workingtime.start, end: workingtime.end})
      end
  end

  defp clocks_data(clocks) do
      case clocks do
        nil -> nil
        _ -> for(clock <- clocks, do: %{id: clock.id, start: clock.start, end: clock.end, status: clock.status})
      end
  end

  defp references_data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      managerId: user.manager_id,
      teamsId: user.teams_id,
      managedTeams: user.managed_teams,
      workingTimes: workingtimes_data(user.workingtimes),
      clock: clocks_data(user.clocks) 
    }
  end

  def show(%{users: users}) do
    #for(user <- users, do: user_data(user))
  end

end
