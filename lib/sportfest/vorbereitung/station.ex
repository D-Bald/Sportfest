defmodule Sportfest.Vorbereitung.Station do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stationen" do
    field :bronze, :integer
    field :gold, :integer
    field :name, :string
    field :silber, :integer
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
