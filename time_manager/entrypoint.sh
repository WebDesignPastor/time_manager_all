#!/bin/bash

cd /app

mix ecto.setup

# waiting the database
while ! pg_isready -h $PGHOST -p $PGPORT -q -U $PGUSER
do
  echo "$(date) - waiting for database..."
  sleep 1
done
echo ----------------------------------
echo "Database is ready !"
echo ----------------------------------

mix ecto.create

mix ecto.migrate

mix phx.server

cd /app

mix deps.get
