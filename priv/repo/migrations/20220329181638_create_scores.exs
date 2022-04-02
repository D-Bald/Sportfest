defmodule Sportfest2.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :medaille, :string
      add :scoreboard, :string
      add :station, :string

      add :schueler_scoreboard_id, references(:schueler_scoreboards, on_delete: :delete_all)
      add :klassen_scoreboard_id, references(:klassen_scoreboards, on_delete: :delete_all)
      add :station_id, references(:stationen, on_delete: :delete_all)

      timestamps()
    end

    create index(:scores, [:schueler_scoreboard_id])
    create index(:scores, [:klassen_scoreboard_id])
    create index(:scores, [:station_id])
  end
end
