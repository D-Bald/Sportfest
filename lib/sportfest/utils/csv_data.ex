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

  def export_stationen_to_csv do
    path = "../../../backups/stationen.csv" |> Path.expand(__DIR__)
    data = [build_station_headers() | Vorbereitung.list_stationen()
                                      |> Enum.map(&build_station_row(&1))]
            |> CSV.encode()
            |> Enum.to_list()
    case File.write(path, data) do
      :ok -> Logger.info("Backup erfolgreich erstellt")
      {:error, reason} -> Logger.info([File_write: "Backup nicht erfolgreich", reason: reason])
    end

  end

  defp build_schueler_attributes(line) do
    {jahrgang, _} = Integer.parse(line["Klasse"])
    %{name: line["Vorname"] <> " " <> line["Nachname"],
      klasse: case Vorbereitung.get_klasse_by_name(line["Klasse"])do
        nil -> case Vorbereitung.create_klasse(line["Klasse"]) do
          {:ok, klasse} -> klasse
          {:error, _} -> raise("Klasse konnte nicht erstellt werden.")
        end
        klasse -> klasse
      end,
      jahrgang: jahrgang
    }
  end

  defp build_station_headers do
    [
      "name",
      "bronze",
      "silber",
      "gold",
      "team_challenge",
      "beschreibung",
      "image_uploads",
      "video_link",
      "einheit",
      "bronze_bedingung",
      "silber_bedingung",
      "gold_bedingung"
    ]
  end
  defp build_station_row(station) do
    [ station.name,
      station.bronze,
      station.silber,
      station.gold,
      station.team_challenge,
      station.beschreibung,
      station.image_uploads,
      station.video_link,
      station.einheit,
      station.bronze_bedingung,
      station.silber_bedingung,
      station.gold_bedingung
    ]
  end
end
