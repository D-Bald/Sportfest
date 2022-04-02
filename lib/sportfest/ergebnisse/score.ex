defmodule Sportfest.Ergebnisse.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :medaille, Ecto.Enum, values: [:bronze, :silber, :gold, :keine], default: :keine

    belongs_to :klassen_scoreboard, Sportfest.Ergebnisse.KlassenScoreboard
    belongs_to :schueler_scoreboard, Sportfest.Ergebnisse.SchuelerScoreboard
    belongs_to :station, Sportfest.Vorbereitung.Station

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:medaille, :klassen_scoreboard_id, :schueler_scoreboard_id, :station_id])
    |> validate_required([:medaille, :station_id])
  end
end
