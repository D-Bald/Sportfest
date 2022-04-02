defmodule Sportfest2.Repo.Migrations.CreateKlassen do
  use Ecto.Migration

  def change do
    create table(:klassen) do
      add :name, :string
      add :schueler, :string

      timestamps()
    end

    create unique_index(:klassen, [:name])
  end
end
