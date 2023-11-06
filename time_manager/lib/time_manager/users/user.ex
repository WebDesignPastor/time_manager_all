defmodule TimeManager.Users.User do
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Clocks.Clock
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :string, default: "employee"
    field :manager_id, :integer
    field :teams_id, {:array, :integer}
    field :managed_teams, {:array, :integer}
    has_many :workingtimes, WorkingTime
    has_many :clocks, Clock

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role, :manager_id, :teams_id, :managed_teams])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/) 
    |> put_password_hash()
  end

  #check if changeset is valid
  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{ password: password }} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
