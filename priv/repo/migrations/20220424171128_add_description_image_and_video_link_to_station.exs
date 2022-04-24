defmodule Sportfest.Repo.Migrations.AddDescriptionImageAndVideoLinkToStation do
  use Ecto.Migration

  def change do
    alter table(:stationen) do
      add :beschreibung, :string
      add :image_uploads, {:array, :string}
      add :video_link, :string
    end
  end
end
