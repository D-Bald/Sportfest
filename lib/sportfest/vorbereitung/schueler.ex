defmodule Sportfest.Vorbereitung.Schueler do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schueler" do
    field :jahrgang, :integer
    field :name, :string

    belongs_to :klasse, Sportfest.Vorbereitung.Klasse
    has_many :scores, Sportfest.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(schueler, attrs) do
    schueler
    |> cast(attrs, [:name, :jahrgang, :klasse_id])
    |> validate_required([:name, :jahrgang, :klasse_id])
  end
end
