defmodule Sportfest.Utils.CSVData do
  @moduledoc """
    Utility Modul zum Einlesen von Schüler:innen-Daten aus CSV Dateien und Erstellen von Backups als CSV
  """
  require Logger
  alias Sportfest.Vorbereitung

  def import_schueler_from_csv(file) do
    file
    |> Path.expand(__DIR__) # Used when read in repo/seeds
    |> File.stream!
    |> CSV.decode(headers: true)
    |> Enum.map(fn {:ok, line} -> build_schueler_attributes(line) end)
    |> Enum.map(fn attrs -> Vorbereitung.create_or_skip_schueler(attrs) end)
  end

  def export_stationen_to_csv(field_names \\ stationen_field_names()) do
    map_repr =
      Sportfest.Vorbereitung.list_stationen()
      |> Enum.map(fn station ->
          Map.from_struct(station)
          |> Map.take(field_names)
        end)

    list_with_sorted_fields =
      Enum.map(map_repr, fn station ->
        Enum.reduce(field_names, [],&[{&1, Map.fetch!(station, &1)} | &2])
        |> Enum.reverse()
      end)

    [field_names | list_with_sorted_fields]
    |> CSV.encode()
    |> Enum.to_list()
  end

  defp build_schueler_attributes(line) do
    {jahrgang, _} = Integer.parse(line["Klasse"])
    %{name: line["Vorname"] <> " " <> line["Nachname"],
      klasse: case Vorbereitung.get_klasse_by_name(line["Klasse"])do
        nil -> case Vorbereitung.create_klasse(%{klasse: line["Klasse"], jahrgang: jahrgang}) do
          {:ok, klasse} -> klasse
          {:error, _} -> raise("Klasse konnte nicht erstellt werden.")
        end
        klasse -> klasse
      end
    }
  end

  defp stationen_field_names do
    [
      :name,
      :bronze,
      :silber,
      :gold,
      :team_challenge,
      :beschreibung,
      # :image_uploads, # noch nicht implementiert
      :video_link,
      :einheit,
      :bronze_bedingung,
      :silber_bedingung,
      :gold_bedingung
    ]
  end
end
