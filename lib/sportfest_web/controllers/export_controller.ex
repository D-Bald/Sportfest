defmodule SportfestWeb.ExportController do
  use SportfestWeb, :controller

  alias Sportfest.Vorbereitung

  def create(conn, %{"resource" => "stationen"}) do
    csv_data = [
        stationen_headers() |
        Vorbereitung.list_stationen()
        |> Enum.map(&build_station_row(&1))
      ]
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"export.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, csv_data)
  end

  defp stationen_headers do
    [
      "name",
      "bronze",
      "silber",
      "gold",
      "team_challenge",
      "beschreibung",
      # "image_uploads", # noch nicht implementiert
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
