# Sportfest
## Nutzungshinweise
### Athentifizierung und Authorisierung
Registrierungs- und Login-Link werden angezeigt, aber die Funktoinalität ist noch nicht implementiert!

### Pfade
- Homepage: `HOSTNAME/`
- Bearbeiten der Medaillen: `HOSTNAME/scores`
- Anzeigen der Rangliste: `HOSTNAME/leaderboard`
- Auflistung zum Bearbeiten der Schüler:innen: `HOSTNAME/schueler`
- (In Planung: Bearbeiten von inaktiven SuS: `HOSTNAME/klassen/:id/show`)
- Auflistung zum Bearbeiten der Stationen: `HOSTNAME/stationen`
- (In Planung: Erklärung der Station und Bearbeiten der Medaillen zu dieser Station: `HOSTNAME/stationen/:id/show`)

### Einschränkung beim Bearbeiten der Stationen
Theoretisch kann bearbeitet werden, ob eine Station eine `team challenge` ist oder nicht. Wenn man diesen Status der Station ändert, funktioniert allerdings zur Zeit der Filter für die Scores nicht mehr korrekt. Daher muss bis zur Behebung des Problems die Station gelöscht und mit dem gewünschten Status neu erstellt werden.

### Import von Schüler:innen
Auf der Seite `HOSTNAME/schueler` können Schüler:innen-Daten durch Hochladen von CSV-Dateien eingelesen werden. Die CSV-Dateien müssen folgende Eigenschaften erfüllen:
- Trennzeichen: Komma (`,`)
- Spalten: `Klasse`, `Vorname`, `Nachname`
- Die Klassenbezeichnung muss am Anfang den Jahrgang als Zahl stehen haben: `5 b)` oder `5.1.1`

## Get Code:
```console
$ git clone https://github.com/D-Bald/Sportfest.git
```
Zum Updaten (`git pull` läuft auf error, da `priv/static/cache_manifest.json` überschrieben wird):
```console
$ git fetch
$ git reset --hard HEAD
$ git merge origin/main
```
## Deployment
### Datenbank
#### Installiere Postgres SQL
https://www.postgresql.org/
#### Konfiguration
Aus der Dokumentation des Phoenix Frameworks:
> "Phoenix assumes that our PostgreSQL database will have a postgres user account with the correct permissions and a password of "postgres"."

#### Erstelle Datenbank `sportfest_prod` für die Sportfest App
```console
$ psql -U postgres
psql (13.6)
Type "help" for help.

postgres=# CREATE DATABASE sportfest_prod
CREATE DATABASE
```

### Set Environment variables
Ausführen der `mix`-Tasks (`mix phx.gen.secret`) im Projektordner.
```console
$ export SECRET_KEY_BASE=$(mix phx.gen.secret)

$ export DATABASE_URL=ecto://postgres:postgres@localhost/sportfest_prod

$ export PHX_HOST=HOSTNAME_ODER_localhost

$ export PORT=4001
```
> Do not copy those values directly, set SECRET_KEY_BASE according to the result of mix phx.gen.secret and DATABASE_URL according to your database address.


### Deployment mit Releases
#### Zuerst Schritte vom lokalen Deployment:
```console
# Initial setup
$ mix deps.get --only prod
$ MIX_ENV=prod mix compile

# Compile assets
$ MIX_ENV=prod mix assets.deploy
```

#### Release erstellen:
```console
$ MIX_ENV=prod mix release
```

#### Run migration:
```console
$ _build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.migrate"
```

#### Start app
```console
$ _build/prod/rel/sportfest/bin/sportfest start
```

ODER

Starten der App im Hintergrund
```console
$ _build/prod/rel/sportfest/bin/sportfest daemon
```
Um die so gestartete App zu stoppen:
```console
$ _build/prod/rel/sportfest/bin/sportfest stop
```