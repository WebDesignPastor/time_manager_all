#!/bin/bash

cd /app

# Get the dependencies
mix deps.get

echo ----------------------------------
echo "Starting Phoenix server..."
echo ----------------------------------

# Wait for the database to be ready
while ! pg_isready -h $PGHOST -p $PGPORT -q -U $PGUSER
do
  echo "$(date) - waiting for database..."
  sleep 1
done

echo ----------------------------------
echo "Database is ready!"
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
echo "Seeding the database..."
echo ----------------------------------

mix run priv/repo/seeds.exs

echo ----------------------------------
echo "Phoenix server is starting..."
echo ----------------------------------

mix phx.server

echo ----------------------------------
echo "Phoenix server started!"
echo ----------------------------------
