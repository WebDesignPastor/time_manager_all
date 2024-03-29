defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock
  alias TimeManager.Users.User
  alias TimeManager.Users

  action_fallback TimeManagerWeb.FallbackController

  plug :authorize_user_request when action in [:clock]

  defp authorize_user_request(conn, _opts) do
    if conn.status == 401 do
      render(conn, :error, message: "Not authorized")
    else
      current_user = conn.assigns[:current_user]
      authorize_user_request_by_role(conn, current_user)
    end
  end
  
  defp authorize_user_request_by_role(conn, current_user) do
    case {conn.params["userID"]} do
      {_requested_user_id} when current_user.role == "general_manager" ->
        conn
      {requested_user_id} ->
        case Users.get_user(requested_user_id) do
          %User{} = requested_user when current_user.id == requested_user.id ->
            conn
          %User{} = requested_user when current_user.role == "manager" and requested_user.manager_id == current_user.id ->
            conn
          nil -> conn |> put_status(:bad_request) |> render(:error, message: "Incorrect userId in request")
          _ -> conn |> put_status(:unauthorized) |> render(:error, message: "Not authorized based on role")
        end
    end
  end

  def clock(conn, %{"userID" => id}) do
    id = String.to_integer(id)
    case Clocks.get_last_clock(id) do
      %Clock{status: false} -> 
        case Clocks.create_clock(id) do
          {:ok, %Clock{} = clock} -> render(conn, :show, clock: clock)
          _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "Clock couldn't be created")
        end
      %Clock{status: true} = last_clock ->
        case Clocks.update_last_clock(last_clock) do
          {:ok, %Clock{} = clock} -> render(conn, :show, clock: clock)
          _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "Clock couldn't be updated")
        end
      nil ->
        case Clocks.create_clock(id) do
          {:ok, %Clock{} = clock}-> render(conn, :show, clock: clock)
          _ -> conn |> put_status(:internal_server_error) |> render(:error, message: "Clock couldn't be created")
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
