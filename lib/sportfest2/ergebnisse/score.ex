defmodule Sportfest2.Ergebnisse.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :medaille, Ecto.Enum, values: [:bronze, :silber, :gold, :keine], default: :keine

    belongs_to :klassen_scoreboard, Sportfest2.Ergebnisse.KlassenScoreboard
    belongs_to :schueler_scoreboard, Sportfest2.Ergebnisse.SchuelerScoreboard
    belongs_to :station, Sportfest2.Vorbereitung.Station

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:medaille, :klassen_scoreboard_id, :schueler_scoreboard_id, :station_id])
    |> validate_required([:medaille, :station_id])
  end
end
