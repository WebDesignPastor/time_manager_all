FROM elixir:latest

RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /app

COPY . /app

ENV MIX_ENV=dev

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

EXPOSE 4000

CMD ["mix", "phx.server"]
