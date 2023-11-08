defmodule TimeManagerWeb.AuthJSON do

  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock

  def auth(%{user: user, token: token}) do
    data(user, token)
  end
  
  def error(%{message: message}) do
    %{error: message} 
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
        %Clock{} -> %{start: clocks.start, end: clocks.end, status: clocks.status}
      end
  end

  defp data(%User{} = user, token) do
    %{
      token: token,
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

end
