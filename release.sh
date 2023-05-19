#!/usr/bin/env sh


echo "Running migrations"
_build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.migrate"

# helper function to create admin, moderator and user accounts if needed
_build/prod/rel/sportfest/bin/sportfest eval "Sportfest.Release.maybe_create_accounts"

# exit 123