defmodule TimeManager.WorkingTimes do
  @moduledoc """
  The WorkingTimes context.
  """
  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Users
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Users.User
  alias TimeManager.Users

  #------ INDEX ---------------------
  def list_user_workingtimes(id) do
    case Users.get_user(id) do
      nil ->
        {:error, :user_not_found}
      user ->
        working_times =
        WorkingTime
        |> where(user_id: ^id)
        |> Repo.all()

        case working_times do
          working_times ->
            {:ok, working_times}
          _ ->
            {:error, :workingtime_not_found}
        end
    end
  end
  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  # def list_workingtime, do Repo.all(WorkingTime)

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
      nil -> {}
      %User{} = user ->
        %WorkingTime{user_id: user.id}
        |> WorkingTime.changeset(attrs)
        |> Repo.insert()

        start_week = Date.beginning_of_week(NaiveDateTime.from_iso8601!(attrs.start), :sunday)
        end_week = Date.end_of_week(NaiveDateTime.from_iso8601!(attrs.end), :sunday)

        startTime = NaiveDateTime.new!(start_week, ~T[00:00:00])
        endTime = NaiveDateTime.new!(end_week, ~T[23:59:59])

        case get_by(id, startTime, endTime) do
          nil -> nil
          _ = workingtimes -> workingtimes
        end
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


  def create_working_times_seed!(attr) do
    %WorkingTime{}
    |> WorkingTime.changeset(attr)
    |> Repo.insert()
  end
end
