defmodule Sportfest.Utils.ScoreCreation do
  @moduledoc """
    Modul zur manuellen Erstellung von Scores, da diese bei neuen Schüler:innen oder Stationen nicht automatisch erstellt werden,
    sondern erst beim ersten Laden der Scores. Da dies zu langen Ladezeiten führt,
    sollten die Scores in Produktion manuell vorgeladen werden
  """
  alias Sportfest.Vorbereitung
  alias Sportfest.Ergebnisse

  def all do
    for station <- Vorbereitung.list_stationen() do
      cond do
        station.team_challenge ->
          for klasse <- Vorbereitung.list_klassen do
            Ergebnisse.create_or_skip_score(station, klasse)
          end
        true ->
          for schueler <- Vorbereitung.list_schueler do
            Ergebnisse.create_or_skip_score(station, schueler)
          end
      end
    end
  end
end
