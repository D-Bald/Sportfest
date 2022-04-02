defmodule Sportfest2.Repo.Migrations.CreateSchuelerScoreboards do
  use Ecto.Migration

  def change do
    create table(:schueler_scoreboards) do
      add :schueler, :string

      add :schueler_id, references(:schueler, on_delete: :delete_all)

      timestamps()
    end

    create index(:schueler_scoreboards, [:schueler_id])
  end
end
Q
