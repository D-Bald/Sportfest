# Sportfest

## Nutzungshinweise

### Athentifizierung und Authorisierung
Registrierungs- und Login-Link werden angezeigt, aber die Funktionalität ist noch nicht implementiert!

### Routen
Jede Route beginnt mit dem festgelegten Host Namen durch `PHX_HOST` (s.u.).

| Route | Beschreibung | Autorisierte Rolle(n) |
|:------|:-------------|:---------------------:|
| `/` | Startseite | `admin`, `moderator`, `user` |
| `/stationen` | Auflistung zum Anzeigen und Bearbeiten der Stationen | `admin`, `moderator`, `user` |
| `/stationen/:id` | Erklärung der Station |`admin`, `moderator`, `user` |
| `/leaderboard` | Anzeigen der Ranglisten | `admin`, `moderator`, `user` |
| `/scores` | Bearbeiten von Medaillen für aktive Schüler:innen für alle Stationen und Klassen | `admin`, `moderator` |
| `/klassen` | Auflistung zum Anzeigen und Bearbeiten der Klassen | `admin`, `moderator` |
| `/klassen/:id` | Bearbeiten von inaktiven Schüler:innen einer Klasse | `admin`, `moderator` |
| `/schueler` | Auflistung zum Bearbeiten der Schüler:innen | `admin` |


### Import von Schüler:innen
Auf der Seite `HOSTNAME/schueler` können Schüler:innen-Daten durch Hochladen von CSV-Dateien eingelesen werden. Die CSV-Dateien müssen folgende Eigenschaften erfüllen:
- Trennzeichen: Komma (`,`)
- Spalten: `Klasse`, `Vorname`, `Nachname`
- Die Klassenbezeichnung muss am Anfang den Jahrgang als Zahl stehen haben: `5 b)` oder `5.1.1`

### Videoeinbettung für Stationen
Es werden nur Links zu Vimeo Videos unterstützt.

## Installation

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
$ sudo git clone https://github.com/D-Bald/Sportfest.git
$ cd Sportfest
$ sudo mix deps.get
$ sudo mix compile
```

### Deployment mit Releases
#### Vorbereiten des Skripts
Benenne das Startskript um:
```console
$ sudo mv setup_and_run.sh.sample setup_and_run.sh
```
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
$ sudo sh setup_and_run.sh
```

Falls noch keine Accounts angelegt wurden, wird hier durch Ausführen der Funktion `Sportfest.Release.maybe_create_accounts/0` die Eingabe einer E-Mail Adresse und eines Passworts für jeweils einen Account mit den Rollen `"admin"`, `"moderator"` und `"user"` gefordert. Die E-Mail Adresse muss ein @ enthalten und das Passwort mindestens 12 Zeichen lang sein.

#### Um die so gestartete App zu stoppen
```console
$ _build/prod/rel/sportfest/bin/sportfest stop
```

#### Option zum Starten der App im Vordergrund
```console
$ _build/prod/rel/sportfest/bin/sportfest start
```

## Lizenz
MIT License. Copyright (c) 2022 David Baldauf.