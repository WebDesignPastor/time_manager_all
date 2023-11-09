defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  plug :is_user_requested when action in [:clock]

  defp is_user_requested(conn, _opts) do
    if conn.status == 401 do render(conn, :error, message: "Not authorized") end

    current_user = conn.assigns[:current_user]
    case conn.assigns[:current_user] do
      %User{role: "general_manager"} ->
        conn
      %User{} = user ->
        if {conn.params["userID"]} == current_user.id do
          conn
        else
          render(conn, :error, message: "trying to access another user")
        end
    end
  end

  def clock(conn, %{"userID" => id}) do
    id = String.to_integer(id)
    case Clocks.get_last_clock(id) do
      %Clock{status: false} -> 
        case Clocks.create_clock(id) do
          {:ok, %Clock{} = clock} -> render(conn, :show, clock: clock)
          _ -> render(conn, :error, message: "Clock couldn't be created")
        end
      %Clock{status: true} = last_clock ->
        case Clocks.update_last_clock(last_clock) do
          {:ok, %Clock{} = clock} -> render(conn, :show, clock: clock)
          _ -> render(conn, :error, message: "Clock couldn't be updated")
        end
      nil ->
        case Clocks.create_clock(id) do
          {:ok, %Clock{} = clock}-> render(conn, :show, clock: clock)
          _ -> render(conn, :error, message: "Clock couldn't be created")
        end
    end
  end

  #def index(conn, _params) do
  #  clocks = Clocks.list_clocks()
  #  render(conn, :index, clocks: clocks)
  #end

  #def create(conn, %{"userID" => id}) do
  #  id = String.to_integer(id)
  #  with {:ok, %Clock{} = clock} <- Clocks.create_clock(id) do
  #    conn
  #    |> put_status(:created)
  #    |> put_resp_header("location", ~p"/api/clocks/#{clock}")
  #    |> render(:show, clock: clock)
  #  end
  #end

  #def show(conn, %{"userID" => id}) do
  #  clock = Clocks.get_clock!(id)
  #  render(conn, :show, clock: clock)
  #end

  #def update(conn, %{"userID" => id, "clock" => clock_params}) do
  #  clock = Clocks.get_clock!(id)

  #  with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
  #    render(conn, :show, clock: clock)
  #  end
  #end

  #def delete(conn, %{"userID" => id}) do
  #  clock = Clocks.get_clock!(id)

  #  with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
  #    send_resp(conn, :no_content, "")
  #  end
  #end
end
