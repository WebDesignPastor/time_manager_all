defmodule TimeManager.WorkingTimes do
  @moduledoc """
  The WorkingTimes context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Users
  alias TimeManager.WorkingTimes.WorkingTime

  def list_user_workingtimes(id) do
    case Users.get_user(id) do
      nil ->
        {:error, :user_not_found}
      user ->
        working_time =
        WorkingTime
        |> where(user_id: ^id)
        |> Repo.all()
        case working_time do
          [] ->
            {:error, :workingtime_not_found}
          _ ->
            {:ok, working_time}
        end
    end
  end


  # def list_user_workingtimes(id) do
  #   user = Repo.get(User, id)

  #   if user do
  #     WorkingTime
  #     |> where(user_id: ^id)
  #     |> Repo.all()
  #     |> case do
  #       [] -> {:error, :no_working_times}
  #       working_times -> {:ok, working_times}
  #     end
  #   else
  #     {:error, :user_not_found}
  #   end
  # end



  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(id, attrs \\ %{}) do
    %WorkingTime{user_id: id}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  def get_by(id, startTime, endTime) do
      query = from(w in WorkingTime, where: w.user_id == ^id and w.start >= ^startTime and w.end <= ^endTime)
      Repo.all(query)
  end
    #  Repo.get_by(WorkingTime, user_id: id, start: startTime, end: endTime)

  def get_one(user_id, id) do
    Repo.get_by(WorkingTime, user_id: user_id, id: id)
  end
end
