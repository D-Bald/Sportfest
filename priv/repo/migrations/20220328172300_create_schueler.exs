defmodule Sportfest2.Repo.Migrations.CreateSchueler do
  use Ecto.Migration

  def change do
    create table(:schueler) do
      add :name, :string
      add :jahrgang, :integer

      add :klasse_id, references(:klassen, on_delete: :delete_all)

      timestamps()
    end

    create index(:schueler, [:klasse_id])
  end
end
