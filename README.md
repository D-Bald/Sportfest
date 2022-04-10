# Sportfest
## Get Code:
```console
$ git clone https://github.com/D-Bald/Sportfest.git
```
## Deployment
### Set-up production database
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
$ mix phx.gen.secret
GENERIERTES_PASSWORT
$ export SECRET_KEY_BASE=GENERIERTES_PASSWORT

$ export DATABASE_URL=ecto://postgres:postgres@localhost/sportfest_prod

$ export PHX_HOST=HOSTNAME_ODER_localhost

$ export PORT=4001
```
Do not copy those values directly, set SECRET_KEY_BASE according to the result of mix phx.gen.secret and DATABASE_URL according to your database address.


### Lokales Deployment mit Elixir und Phoenix Installation
```console
# Initial setup

$ mix deps.get --only prod

$ MIX_ENV=prod mix compile

# Compile assets

$ MIX_ENV=prod mix assets.deploy

# Custom tasks (like DB migrations)

$ MIX_ENV=prod mix ecto.migrate

# Finally run the server

$ MIX_ENV=prod mix phx.server
```

Für das starten des Servers im detached mode letzte Zeile ersetzen durch
ODER
```console
$ PORT=4001 MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
```

### Ergänzung für allg. Deployment mit Releases
Zuerst Schritte vom lokalen Deployment

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