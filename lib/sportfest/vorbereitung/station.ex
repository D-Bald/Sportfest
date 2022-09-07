defmodule Sportfest.Vorbereitung.Station do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stationen" do
    field :name, :string
    field :bronze, :integer, default: 1 # Punkte, die für eine Bronze-Medaille vergeben werden
    field :silber, :integer, default: 2 # Punkte, die für eine Silber-Medaille vergeben werden
    field :gold, :integer, default: 3 # Punkte, die für eine Gold-Medaille vergeben werden
    field :team_challenge, :boolean, default: false
    field :beschreibung, :string
    field :image_uploads, {:array, :string}	# Pfade zu den hochgeladenen Bildern
    field :video_link, :string
    field :einheit, :string
    field :bronze_bedingung, :string
    field :silber_bedingung, :string
    field :gold_bedingung, :string

    has_many :scores, Sportfest.Ergebnisse.Score

    timestamps()
  end

  @doc false
  def changeset(station, attrs) do
    station
    |> cast(attrs, [:name, :bronze, :silber, :gold, :team_challenge,
                    :beschreibung, :image_uploads, :video_link, :einheit, :bronze_bedingung, :silber_bedingung, :gold_bedingung])
    |> validate_required([:name, :bronze, :silber, :gold, :team_challenge])
    |> unique_constraint(:name)
  end
end
