defmodule Sportfest2.Ergebnisse.SchuelerScoreboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schueler_scoreboards" do

    belongs_to :schueler, Sportfest2.Vorbereitung.Schueler
    has_many :scores, Sportfest2.Ergebnisse.Score


    timestamps()
  end

  @doc false
  def changeset(schueler_scoreboard, attrs) do
    schueler_scoreboard
    |> cast(attrs, [:schueler_id])
    |> validate_required([:schueler_id])
  end
end
