defmodule Sportfest.Ergebnisse.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :medaille, Ecto.Enum, values: [:bronze, :silber, :gold, :keine], default: :keine

    belongs_to :klasse, Sportfest.Vorbereitung.Klasse
    belongs_to :schueler, Sportfest.Vorbereitung.Schueler
    belongs_to :station, Sportfest.Vorbereitung.Station

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:medaille, :klasse_id, :schueler_id, :station_id])
    |> validate_required([:medaille, :klasse_id, :station_id])
  end
end
