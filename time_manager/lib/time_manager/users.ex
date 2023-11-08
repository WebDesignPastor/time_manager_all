defmodule TimeManager.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  defp last_clock(user_id) do
    Clock
    |> where(user_id: ^user_id)
    |> order_by(desc: :id)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
    get user by email
  """
  def get_by_email(email) do

    user_with_clock =
      User
      |> where(email: ^email)
      |> Repo.one()
      |> Repo.preload([:workingtimes])
      |> case do
        nil -> nil
        user -> %{user | clocks: last_clock(user.id)}
      end

    filter_workingtimes(user_with_clock)
  end

  def get_by_id(id) do
    user_with_clock =
      User
      |> where(id: ^id)
      |> Repo.one()
      |> Repo.preload([:workingtimes])
      |> case do
        nil -> nil
        user -> %{user | clocks: last_clock(user.id)}
      end

    filter_workingtimes(user_with_clock)
  end

  defp filter_workingtimes(user) do
    case user do
      nil -> {}
      user -> 
        { start_of_week, end_of_week } = find_current_week()

        user_with_weekly_time =
          %User{
            user |
            workingtimes: 
              case user.workingtimes do
                [] -> []
                workingtimes -> 
                  Enum.filter(workingtimes, fn workingtime -> 
                    Date.compare(workingtime.start, start_of_week) != :lt and
                    Date.compare(workingtime.end, end_of_week) != :gt
                  end)
              end,
          }
        {:ok, user_with_weekly_time}
    end
  end

  defp find_current_week() do
    {current_date, _ }  = :calendar.universal_time()

    {_, today} = Date.from_erl(current_date)

    start_of_week = Date.beginning_of_week(today, :sunday)
    end_of_week = Date.end_of_week(today, :sunday)
    { start_of_week, end_of_week }
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(username, email, password) do
    %User{}
    |> User.changeset(%{username: username, email: email, password: password})
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_by(username, email) do
    Repo.get_by(User, username: username, email: email)
  end

end
