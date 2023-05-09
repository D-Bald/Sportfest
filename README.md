# Sportfest

## Nutzungshinweise

### Login
Es gibt noch keine personalisierten Accounts. Zurzeit wird jeweils ein Account mit der Rolle `admin`, `moderator` und `user` angelegt.

### Routen
Jede Route beginnt mit dem festgelegten Host Namen durch `PHX_HOST` (s.u.).

| Route | Beschreibung | Autorisierte Rolle(n) |
|:------|:-------------|:---------------------:|
| `/` | Startseite | `admin`, `moderator`, `user`, anonyme:r Nutzer:in |
| `/users/log_in` | Login um Zugang zu den anderen Seiten zu erhalten. | anonyme:r Nutzer:in |
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
Es werden aktuell nur Links zu Videos auf [Vimeo](https://vimeo.com/) unterstützt.

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
## TODO
### Bug-fixes
- Fehler: Ändern der Klasse eines Schülers ändert nicht den foreign key für `klasse` des zum Schüler gehörenden Scores. Dadurch wird der Score in der Medaillenbearbeitung in der falschen (vorherigen) Klasse angezeigt.
- Fehler beim Öffnen des Leaderboards, wenn in einem Jahrgang kein:e Schüler:in eingetragen ist: https://github.com/D-Bald/Sportfest/blob/f27d2f235060540c03a95979fd0bb7e56853c240/lib/sportfest_web/live/leaderboard_live/index.html.heex#L133
- Tests fixen und vervollständigen (insb. Integration Tests für LiveViews)

### Dokumentation
- Examples in Dokumentationen checken: würden sie so durch doc-test gehen?
- Module doc bearbeiten/hinzufügen
- Beschreibung der Anwendung in application in mix.ex ändern/angeben

### Inhalt
- Impressum hinzufügen
- Export von Daten in CSV (in einen angegebenen Ordner) (https://fullstackphoenix.com/tutorials/csv-export)
  - Scores
  - Stationen (funktioniert noch nicht in produktion)
- Übersetzung der Validierungs-Errors
- Anzeigebild für Stationen
  - Feld in Schema und Migration hinzufügen
  - Upload ermöglichen
  - Anzeige neben Namen in Auflistung aller Stationen
- View für Accountverwaltung für Admins (Hinzufügen neuer Accounts; Bearbeiten und Löschen anderer Accounts)

### Maintenance
- Zu [NimbleCSV](https://hexdocs.pm/nimble_csv/NimbleCSV.html)  wechseln
- Deployment mit Docker

### Performance
- Repo.preload nur falls nötig durchführen, um die ausgetauschte Datenmenge und die Anzahl an Datenbank Queries zu reduzieren.

## Lizenz
MIT License. Copyright (c) 2022 David Potschka.