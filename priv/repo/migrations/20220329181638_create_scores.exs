defmodule Sportfest.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :medaille, :string

      add :schueler_id, references(:schueler, on_delete: :delete_all)
      add :klasse_id, references(:klassen, on_delete: :delete_all)
      add :station_id, references(:stationen, on_delete: :delete_all)

      timestamps()
    end

    # TODO: optimize indeces
    create index(:scores, [:schueler_id])
    create index(:scores, [:klasse_id])
    create index(:scores, [:station_id])
  end
end
