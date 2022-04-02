defmodule Sportfest2.Vorbereitung.Schueler do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schueler" do
    field :jahrgang, :integer
    field :name, :string

    belongs_to :klasse, Sportfest2.Vorbereitung.Klasse
    has_one :schueler_scoreboard, Sportfest2.Ergebnisse.SchuelerScoreboard

    timestamps()
  end

  @doc false
  def changeset(schueler, attrs) do
    schueler
    |> cast(attrs, [:name, :jahrgang, :klasse_id])
    |> validate_required([:name, :jahrgang, :klasse_id])
  end
end
