defmodule Sportfest2.Ergebnisse.KlassenScoreboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "klassen_scoreboards" do

    belongs_to :klasse, Sportfest2.Vorbereitung.Klasse
    has_many :scores, Sportfest2.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(klassen_scoreboard, attrs) do
    klassen_scoreboard
    |> cast(attrs, [:klasse_id])
    |> validate_required([:klasse_id])
  end
end
