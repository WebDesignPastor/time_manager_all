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

echo ----------------------------------
echo "Dropping database..."
echo ----------------------------------

mix ecto.drop

echo ----------------------------------
echo "Creating database..."
echo ----------------------------------


mix ecto.create

echo ----------------------------------
echo "Running database migrations..."
echo ----------------------------------

mix ecto.migrate

echo ----------------------------------
echo "Installing Phoenix dependencies..."
echo ----------------------------------

mix deps.get

echo ----------------------------------
echo "Starting Phoenix server..."
echo ----------------------------------

mix phx.server

echo ----------------------------------
echo "Phoenix server started !"
echo ----------------------------------
