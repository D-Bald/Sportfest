#!/bin/sh

echo "Setting environment variables"
export SECRET_KEY_BASE=SICHERES_PASSWORT
export DATABASE_URL=ecto://postgres:postgres@localhost/sportfest_prod
export PHX_HOST=HOSTNAME_ODER_LOCALHOST
export PORT=4001

echo "Loading dependencies to compile code and assets"
# initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile
# compile assets
MIX_ENV=prod mix assets.deploy

echo "Building release"
MIX_ENV=prod mix release

echo "Running migrations"
_build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.migrate"

# helper function to create admin, moderator and user account if needed
_build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.maybe_create_accounts"

# echo "Running app as daemon"
_build/prod/rel/sportfest/bin/sportfest daemon