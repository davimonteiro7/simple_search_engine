FROM bitwalker/alpine-elixir:latest as build

COPY . .

RUN mix deps.get && \
    mix distillery.init && \
    MIX_ENV=prod mix distillery.release

RUN mkdir /export
RUN tar -xf "./_build/prod/rel/simple_search_engine/releases/0.1.0/simple_search_engine.tar.gz" -C /export

FROM pentacent/alpine-erlang-base:latest

EXPOSE 4000
ENV REPLACE_OS_VARS=true \
    PORT=4000

COPY --from=build /export/ .

USER default
ENTRYPOINT ["/opt/app/bin/simple_search_engine"]
CMD ["foreground"]
