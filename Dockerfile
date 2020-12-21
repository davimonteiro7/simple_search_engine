FROM bitwalker/alpine-elixir:latest as build

COPY . .

RUN export MIX_ENV=prod && \
    mix deps.get && \
    mix release

RUN APP_NAME="simple_search_engine"
RUN RELEASE_DIR="ls -d _build/prod/rel/$APP_NAME/releases/*/"
RUN mkdir /export
RUN tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

FROM pentacent/alpine-erlang-base:latest

EXPOSE 4000
ENV REPLACE_OS_VARS=true \
    PORT=4000

COPY --from=build /export/ .

USER default
ENTRYPOINT ["/otp/app/bin/simple_search_engine"]
CMD ["foreground"]
