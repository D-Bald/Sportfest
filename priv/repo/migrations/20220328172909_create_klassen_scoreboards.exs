defmodule Sportfest.Repo.Migrations.CreateKlassenScoreboards do
  use Ecto.Migration

  def change do
    create table(:klassen_scoreboards) do
      add :klasse, :string

      add :klasse_id, references(:klassen, on_delete: :delete_all)

      timestamps()
    end

    create index(:klassen_scoreboards, [:klasse_id])
  end
end
