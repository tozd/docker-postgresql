#!/bin/bash -e

# An example script to run PostgreSQL in production. It uses data volumes under the $DATA_ROOT directory.
# By default /srv.

NAME='postgresql'
DATA_ROOT='/srv'
POSTGRESQL_DATA="${DATA_ROOT}/${NAME}/data"
POSTGRESQL_LOG="${DATA_ROOT}/${NAME}/log"

mkdir -p "$POSTGRESQL_DATA"
mkdir -p "$POSTGRESQL_LOG"

docker stop "${NAME}" || true
sleep 1
docker rm "${NAME}" || true
sleep 1
docker run --detach=true --restart=always --name "${NAME}" --volume "${POSTGRESQL_LOG}:/var/log/postgresql" --volume "${POSTGRESQL_DATA}:/var/lib/postgresql" tozd/postgresql
