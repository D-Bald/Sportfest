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

### Import von Schüler:innen
Auf der Seite `HOSTNAME/schueler` können Schüler:innen-Daten durch Hochladen von CSV-Dateien eingelesen werden. Die CSV-Dateien müssen folgende Eigenschaften erfüllen:
- Trennzeichen: Komma (`,`)
- Spalten: `Klasse`, `Vorname`, `Nachname`
- Die Klassenbezeichnung muss am Anfang den Jahrgang als Zahl stehen haben: `5 b)` oder `5.1.1`

### Videoeinbettung für Stationen
Es werden nur Links zu Youtube Videos unterstützt.

## Deployment

### Datenbank
#### Installiere Postgres SQL
https://www.postgresql.org/
#### Konfiguration
Aus der [Dokumentation des Phoenix Frameworks](https://hexdocs.pm/phoenix/up_and_running.html):
> "Phoenix assumes that our PostgreSQL database will have a postgres user account with the correct permissions and a password of "postgres"."
Falls das Password noch nicht stimmt:
```console
$ psql -U postgres
psql (13.6)
Type "help" for help.

postgres=# ALTER USER postgres PASSWORD 'postgres';
ALTER ROLE
```

#### Erstelle Datenbank `sportfest_prod` für die Sportfest App
```console
$ psql -U postgres
psql (13.6)
Type "help" for help.

postgres=# CREATE DATABASE sportfest_prod;
CREATE DATABASE
```

### Code herunterladen
```console
$ git clone https://github.com/D-Bald/Sportfest.git
```
Zum Updaten (`git pull` läuft auf error, da `priv/static/cache_manifest.json` überschrieben wird):
```console
$ git fetch
$ git reset --hard HEAD
$ git merge origin/main
```

### Deployment mit Releases
#### Bearbeiten der Umgebungsvariablen im Skript `create_realease_and_start.sh`
Generiere eine sicheres Passwort für `SECRET_KEY_BASE` durch Ausführen folgender Zeile im Projektordner ([Phoenix Installation](https://hexdocs.pm/phoenix/1.6.6/installation.html) vorausgesetzt):
```console
$ mix phx.gen.secret
```
Setze das generierte Passwort in der entsprechenden Zeile im Skript ein.

Ändere auch den Eintrag für `PHX_HOST`.

Vgl. auch Hinweis aus der [Phoenix Dokumentation](https://hexdocs.pm/phoenix/1.6.6/deployment.html):
> "Do not copy those values directly, set `SECRET_KEY_BASE` according to the result of `mix phx.gen.secret` and `DATABASE_URL` according to your database address."

#### Ausführen des Skripts
```console
$ sudo sh create_realease_and_start.sh
```

#### Um die so gestartete App zu stoppen
```console
$ _build/prod/rel/sportfest/bin/sportfest stop
```

#### Andere Option zum Starten der App
```console
$ _build/prod/rel/sportfest/bin/sportfest start
```