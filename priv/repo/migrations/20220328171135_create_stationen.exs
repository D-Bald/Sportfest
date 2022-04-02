defmodule Sportfest2.Repo.Migrations.CreateStationen do
  use Ecto.Migration

  def change do
    create table(:stationen) do
      add :name, :string
      add :bronze, :integer
      add :silber, :integer
      add :gold, :integer
      add :team_challenge, :boolean

      timestamps()
    end

    create unique_index(:stationen, [:name])
  end
end
