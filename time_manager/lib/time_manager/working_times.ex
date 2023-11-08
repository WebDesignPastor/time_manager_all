defmodule TimeManager.WorkingTimes do
  @moduledoc """
  The WorkingTimes context.
  """
  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Users
  alias TimeManager.WorkingTimes.WorkingTime

  #------ INDEX ---------------------
  def list_user_workingtimes(id) do
    case Users.get_user(id) do
      nil ->
        {:error, :user_not_found}
      user ->
        working_times =
        WorkingTime |> where(user_id: ^id) |> Repo.all()
        IO.inspect(working_times)
        case working_times do
          working_times ->
            IO.inspect('Tableau non vide')
            {:ok, working_times}
          _ ->
            IO.inspect('tableau vide')
            {:error, :workingtime_not_found}
        end
    end
  end

  def list_workingtime, do Repo.all(WorkingTime)

  def get_working_time(id), do: Repo.get(WorkingTime, id)

  def get_by(id, startTime, endTime) do
    query = from(w in WorkingTime, where: w.user_id == ^id and w.start >= ^startTime and w.end <= ^endTime)
    Repo.all(query)
  end

  #  Repo.get_by(WorkingTime, user_id: id, start: startTime, end: endTime)

  def get_one(user_id, id) do
    Repo.get_by(WorkingTime, user_id: user_id, id: id)
  end


  #------ CREATE ---------------------

  def create_working_time(id, attrs \\ %{}) do
    case Users.get_user(id) do
      nil -> {:error, :user_not_found}
      user ->
        %WorkingTime{user_id: id}
        |> WorkingTime.changeset(attrs)
        |> Repo.insert()
    end
  end


  #------ UPDATE ------------------------------

  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end


  #------ DELETE ---------------------
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end
end
