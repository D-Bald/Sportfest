# Sportfest

## Deployment
### Set Environment variables
```console 
$ export SECRET_KEY_BASE=$(mix phx.gen.secret)

$ export DATABASE_URL=ecto://postgres:postgres@localhost/sportfest_prod

$ export PHX_HOST=sportfest.davidbaldauf.me

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
PORT=4001 MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
```

### Ergänzung für allg. Deployment mit Releases
=> Zuerst Schritte vom lokalen Deployment
Dann:
```console
$ mix phx.gen.release
...
$ MIX_ENV=prod mix release
```

#### Setup production database
```console
$ psql -U postgres
psql (13.6)
Type "help" for help.

postgres=# CREATE DATABASE sportfest_prod
CREATE DATABASE
```

run migration:
```console
$ _build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.migrate"
```

#### Start App
```console
$ _build/prod/rel/sportfest/bin/sportfest start
```