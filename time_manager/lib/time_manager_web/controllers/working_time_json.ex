defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.WorkingTimes.WorkingTime

  def index(%WorkingTime{} = time) do
    %{data: data(time)}
  end

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    case workingtimes do
      %WorkingTime{} -> data(workingtimes)
      _ -> for(working_time <- workingtimes, do: data(working_time))
    end
  end

  def error(%{message: message}) do
    %{error: message} 
  end

  #%{data: for(working_time <- workingtimes, do: data(working_time))}
  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    %{
      start: working_time.start,
      end: working_time.end,
      user_id: working_time.user_id
    }
  end
end
