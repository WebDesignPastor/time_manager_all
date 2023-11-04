defmodule TimeManager.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :status, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:start, :end, :status])
    |> validate_required([:status])
  end
end
