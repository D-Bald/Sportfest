# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sportfest.Repo.insert!(%Sportfest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Sportfest.Vorbereitung
alias Sportfest.Ergebnisse

for jahrgang <- 5..8  do
  for team <- 1..2 do
    for kl <- 1..3 do
      {:ok, _} = Vorbereitung.create_klasse("#{jahrgang}.#{team}.#{kl}")
    end
  end
end
for number <- 1..20 do
  {:ok, _} = Vorbereitung.create_schueler(Vorbereitung.get_klasse!(1), %{jahrgang: 5, name: "Schüler#{number}"})
end
for number <- 21..40 do
  {:ok, _} = Vorbereitung.create_schueler(Vorbereitung.get_klasse!(2), %{jahrgang: 5, name: "Schüler#{number}"})
end
for number <- 41..60 do
  {:ok, _} = Vorbereitung.create_schueler(Vorbereitung.get_klasse!(7), %{jahrgang: 6, name: "Schüler#{number}"})
end

{:ok, weitsprung } = Vorbereitung.create_station(%{name: "Weitsprung"})
{:ok, sprint } = Vorbereitung.create_station(%{name: "Sprint"})
{:ok, fußball } = Vorbereitung.create_station(%{name: "Fußball", team_challenge: true})
