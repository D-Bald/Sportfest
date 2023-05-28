defmodule SportfestWeb.ExportController do
  use SportfestWeb, :controller

  def create(conn, %{"resource" => "stationen"}) do
    csv_data =
      Sportfest.Utils.CSVData.export_stationen_to_csv()
      |> to_string()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"export.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, csv_data)
  end
end
