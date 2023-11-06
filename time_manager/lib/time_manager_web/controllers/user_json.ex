defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    for(user <- users, do: user_data(user))
  end

  def error(%{message: message}) do
    %{error: message} 
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    data(user)
  end

  # /users/:userId
  def references_show(%{user: user}) do
    references_data(user)
  end

  def full_user_show(%{user: user}) do
    user_data(user)
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

  defp user_data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      managerId: user.manager_id,
      teamsId: user.teams_id,
      managedTeams: user.managed_teams,
    }
  end

  defp data(%User{} = user) do
    %{
      username: user.username,
      email: user.email,
    }
  end
end
