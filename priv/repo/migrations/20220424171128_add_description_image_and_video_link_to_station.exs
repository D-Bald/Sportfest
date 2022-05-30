defmodule Sportfest.Repo.Migrations.AddDescriptionImageAndVideoLinkToStation do
  use Ecto.Migration

  def change do
    alter table(:stationen) do
      add :beschreibung, :text
      add :image_uploads, {:array, :string}
      add :video_link, :string
      add :einheit, :string
      add :bronze_bedingung, :string
      add :silber_bedingung, :string
      add :gold_bedingung, :string
    end
  end
end
