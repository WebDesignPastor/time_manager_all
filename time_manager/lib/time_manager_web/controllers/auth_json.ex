defmodule TimeManagerWeb.AuthJSON do

  alias TimeManager.Users.User

  def auth(%{user: user, token: token}) do
    data(user, token)
  end
  
  def error(%{message: message}) do
    %{error: message} 
  end

  defp workingtimes_data(workingtimes) do
      for(workingtime <- workingtimes, do: %{start: workingtime.start, end: workingtime.end})
  end

  defp clocks_data(clocks) do
      for(clock <- clocks, do: %{start: clock.start, end: clock.end, status: clock.status})
  end

  defp data(%User{} = user, token) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      token: token,
      manager_id: user.manager_id,
      teams_id: user.teams_id,
      managed_teams: user.managed_teams,
      workingtimes: workingtimes_data(user.workingtimes),
      clocks: clocks_data(user.clocks)
    }
  end

end
