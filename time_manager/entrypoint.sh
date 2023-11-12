#!/bin/bash

cd /app

echo ----------------------------------
echo "Creating database, migration and seeds"
echo ----------------------------------

mix ecto.setup

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
echo "Phoenix server is starting..."
echo ----------------------------------

mix phx.server

echo ----------------------------------
echo "Phoenix server started!"
echo ----------------------------------
