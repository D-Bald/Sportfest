#!/bin/sh

# set environment variables
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL=ecto://postgres:postgres@localhost/sportfest_prod
export PHX_HOST=HOSTNAME_ODER_localhost
export PORT=4001

# load dependencies to compile code and assets:
# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# build release
MIX_ENV=prod mix release

# run migrations
_build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.migrate"

# run as daemon
_build/prod/rel/sportfest/bin/sportfest daemon