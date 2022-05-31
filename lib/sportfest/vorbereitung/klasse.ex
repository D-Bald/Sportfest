defmodule Sportfest.Vorbereitung.Klasse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "klassen" do
    field :jahrgang, :integer
    field :name, :string

    has_many :schueler, Sportfest.Vorbereitung.Schueler
    has_many :scores, Sportfest.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(klasse, attrs) do
    klasse
    |> cast(attrs, [:name, :jahrgang])
    |> validate_required([:name, :jahrgang])
    |> unique_constraint(:name)
  end
end
