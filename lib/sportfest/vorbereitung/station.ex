defmodule Sportfest.Vorbereitung.Station do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stationen" do
    field :name, :string
    field :bronze, :integer, default: 1
    field :silber, :integer, default: 2
    field :gold, :integer, default: 3
    field :team_challenge, :boolean, default: false

    has_many :scores, Sportfest.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(station, attrs) do
    station
    |> cast(attrs, [:name, :bronze, :silber, :gold, :team_challenge])
    |> validate_required([:name, :bronze, :silber, :gold])
    |> unique_constraint(:name)
  end
end
