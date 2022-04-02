# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sportfest2.Repo.insert!(%Sportfest2.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
for jahrgang <- 5..8 do
  for team <- 1..2 do
    for kl <- 1..3 do
      {:ok, klasse} = Sportfest2.Vorbereitung.create_klasse("#{jahrgang}.#{team}.#{kl}")
      {:ok, _} = Sportfest2.Ergebnisse.create_klassen_scoreboard(klasse)
    end
  end
end
for number <- 1..20 do
  {:ok, _} = Sportfest2.Vorbereitung.create_schueler(Sportfest2.Vorbereitung.get_klasse!(1), %{jahrgang: 5, name: "Schüler#{number}"})
end
for number <- 21..40 do
  {:ok, _} = Sportfest2.Vorbereitung.create_schueler(Sportfest2.Vorbereitung.get_klasse!(2), %{jahrgang: 5, name: "Schüler#{number}"})
end
for number <- 41..60 do
  {:ok, _} = Sportfest2.Vorbereitung.create_schueler(Sportfest2.Vorbereitung.get_klasse!(7), %{jahrgang: 6, name: "Schüler#{number}"})
end

for schueler <- Sportfest2.Vorbereitung.list_schueler() do
  {:ok, _scoreboard} = Sportfest2.Ergebnisse.create_schueler_scoreboard(schueler)
end

{:ok, _ } = Sportfest2.Vorbereitung.create_station(%{name: "Weitsprung", bronze: 5, silber: 10, gold: 15})
{:ok, _ } = Sportfest2.Vorbereitung.create_station(%{name: "Sprint", bronze: 10, silber: 15, gold: 20})
{:ok, _ } = Sportfest2.Vorbereitung.create_station(%{name: "Fußball", bronze: 50, silber: 100, gold: 200, team_challenge: true})
