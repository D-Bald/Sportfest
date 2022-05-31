defmodule Sportfest.Vorbereitung.Schueler do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schueler" do
    field :name, :string
    field :aktiv, :boolean, default: true

    belongs_to :klasse, Sportfest.Vorbereitung.Klasse
    has_many :scores, Sportfest.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(schueler, attrs) do
    schueler
    |> cast(attrs, [:name, :aktiv, :klasse_id])
    |> validate_required([:name, :klasse_id])
  end
end
