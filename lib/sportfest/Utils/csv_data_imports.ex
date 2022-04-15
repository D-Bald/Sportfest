defmodule Sportfest.Utils.CSVDataImports do
@moduledoc """
    Utility Modul zum einlesen von Schüler:innen-Daten
  """

  alias Sportfest.Vorbereitung

  def add_schueler_from_csv(file) do
    file
    |> Path.expand(__DIR__) # Used when read in repo/seeds
    |> File.stream!
    |> CSV.decode(headers: true)
    |> Enum.map(fn {:ok, line} -> build_schueler_attributes(line) end)
    |> Enum.map(fn attrs -> Vorbereitung.get_or_create_schueler(attrs) end)
    |> Enum.map(fn {:ok, schueler} -> schueler end)
  end

  def build_schueler_attributes(line) do
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
end
