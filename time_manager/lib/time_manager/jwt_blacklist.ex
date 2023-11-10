defmodule TimeManager.JwtBlacklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jwt_blacklist" do
    field :token, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(jwt_blacklist, attrs) do
    jwt_blacklist
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
