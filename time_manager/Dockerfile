FROM elixir:latest

RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /app

COPY . /app

RUN mix local.hex --force && \
    mix local.rebar --force

EXPOSE 4000

CMD ["mix", "phx.server"]
