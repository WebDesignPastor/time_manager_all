defmodule TimeManager.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string
      add :teams_id, :integer
      add :managed_teams, {:array, :integer}
      add :manager_id, :integer 
    end
  end
end
