#!/bin/bash -e

# An example script to run PostgreSQL in production. It uses data volumes under the $DATA_ROOT directory.
# By default /srv. After first run, you can connect to the PostgreSQL as an administrator from the inside
# the container, by default:
#
# docker exec -t -i postgresql /bin/bash
#
# psql -U postgres postgres
#
# You can create users:
#
# createuser -U postgres -DRS -P <USERNAME>
#
# You can create database:
#
# createdb -U postgres -O <USERNAME> <DBNAME>
#
# You can install PostGIS into your database by connecting to it and running:
#
# CREATE EXTENSION postgis;

export NAME='postgresql'
export DATA_ROOT='/srv'
export POSTGRESQL_DATA="${DATA_ROOT}/${NAME}/data"
export POSTGRESQL_LOG="${DATA_ROOT}/${NAME}/log"

mkdir -p "$POSTGRESQL_DATA"
mkdir -p "$POSTGRESQL_LOG"

docker stop "${NAME}" || true
sleep 1
docker rm "${NAME}" || true
sleep 1
docker run --detach=true --restart=always --name "${NAME}" --volume "${POSTGRESQL_LOG}:/var/log/postgresql" --volume "${POSTGRESQL_DATA}:/var/lib/postgresql" tozd/postgresql
