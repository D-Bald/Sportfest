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

{:ok, _ } = Vorbereitung.create_station(%{name: "5.6 Spinnenhof - Klassenstaffellauf", team_challenge: true})
{:ok, _ } = Vorbereitung.create_station(%{name: "1.1 Paper Toss - Doppeltisch"})
{:ok, _ } = Vorbereitung.create_station(%{name: "1.2 Paper Toss - Übers Tafeleck"})

# Hinzufügen von jeweils einem Konto für Schüler:innen, Lehrer:innen und Adminstrator:innen
Sportfest.Accounts.create_admin(%{email: "admin@test", password: "hallohallohallo"})
{:ok, moderator} = Sportfest.Accounts.register_user(%{email: "moderator@test", password: "hallohallohallo"})
Sportfest.Accounts.set_moderator_role(moderator)
Sportfest.Accounts.register_user(%{email: "user@test", password: "hallohallohallo"})
