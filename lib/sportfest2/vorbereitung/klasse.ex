defmodule Sportfest2.Vorbereitung.Klasse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "klassen" do
    field :name, :string

    has_one :klassen_scoreboard, Sportfest2.Ergebnisse.KlassenScoreboard
    has_many :schueler, Sportfest2.Vorbereitung.Schueler

    timestamps()
  end

  @doc false
  def changeset(klasse, attrs) do
    klasse
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
