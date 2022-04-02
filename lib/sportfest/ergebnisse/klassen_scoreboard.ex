defmodule Sportfest.Ergebnisse.KlassenScoreboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "klassen_scoreboards" do

    belongs_to :klasse, Sportfest.Vorbereitung.Klasse
    has_many :scores, Sportfest.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(klassen_scoreboard, attrs) do
    klassen_scoreboard
    |> cast(attrs, [:klasse_id])
    |> validate_required([:klasse_id])
  end
end
