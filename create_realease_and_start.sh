#!/bin/sh

echo "Setting environment variables"
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL=ecto://postgres:postgres@localhost/sportfest_prod
export PHX_HOST=HOSTNAME_ODER_localhost
export PORT=4001

echo "Loading dependencies to compile code and assets"
# initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile
# compile assets
$ MIX_ENV=prod mix assets.deploy

echo "Building release"
MIX_ENV=prod mix release

echo "Running migrations"
_build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.migrate"

echo "Running app as daemon"
_build/prod/rel/sportfest/bin/sportfest daemon