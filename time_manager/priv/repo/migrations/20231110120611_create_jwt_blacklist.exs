defmodule TimeManager.Repo.Migrations.CreateJwtBlacklist do
  use Ecto.Migration

  def change do
    create table(:jwt_blacklist) do
      add :token, :string

      timestamps(type: :utc_datetime)
    end
  end
end
