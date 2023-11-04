defmodule TimeManagerWeb.ClockJSON do
  alias TimeManager.Clocks.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  def error(%{message: message}) do
    %{error: message} 
  end

  defp data(%Clock{} = clock) do
    %{
      id: clock.id,
      start: clock.start,
      end: clock.end,
      status: clock.status,
      user_id: clock.user_id
    }
  end
end
