defmodule TimeManager.Clocks do
  @moduledoc """
  The Clocks context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Clocks.Clock

  def get_last_clock(id) do
     Clock
     |> where(user_id: ^id)
     |> order_by(desc: :id)
     |> limit(1)
     |> Repo.one()
  end

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(id) do
    current_time = NaiveDateTime.local_now()

    IO.inspect("create_clock")
    clock_params = %{
      start: current_time,
      status: true,
    }

    %Clock{user_id: id}
    |> Clock.changeset(clock_params)
    |> Repo.insert()
  end

  def create_clock!(id, startTime, endTime, status) do
    clock_params = %{start: startTime, end: endTime, status: status}

    %Clock{user_id: id}
    |> Clock.changeset(clock_params)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_last_clock(%Clock{} = clock) do
    current_time = NaiveDateTime.local_now()

    date_start = NaiveDateTime.to_date(clock.start)
    date_today = NaiveDateTime.to_date(current_time)

    case date_today != date_start do
      true -> 
          date_start_time_end = NaiveDateTime.new!(date_start, ~T[23:59:59])
          clock
          |> Clock.changeset(%{status: false, end: date_start_time_end})
          |> Repo.update()

          date_start_time_start = NaiveDateTime.new!(date_today, ~T[00:00:00])
          create_clock!(clock.user_id, date_start_time_start, current_time, false)
      false -> 
        clock_params = %{status: false, end: current_time}

        clock
        |> Clock.changeset(clock_params)
        |> Repo.update()
    end
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

end
