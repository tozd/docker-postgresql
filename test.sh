#!/bin/sh

set -e

cleanup_docker=0
cleanup_network=0
cleanup() {
  set +e

  if [ "$cleanup_docker" -ne 0 ]; then
    echo "Logs"
    docker logs test

    echo "Stopping Docker image"
    docker stop test
    docker rm -f test
  fi

  if [ "$cleanup_network" -ne 0 ]; then
    echo "Removing Docker network"
    docker network rm testnet
  fi
}

trap cleanup EXIT

echo "Creating Docker network"
time docker network create testnet
cleanup_network=1

echo "Running Docker image"
docker run -d --name test --network testnet -e LOG_TO_STDOUT=1 -e PGSQL_ROLE_1_USERNAME=test -e PGSQL_ROLE_1_PASSWORD=test -e PGSQL_DB_1_NAME=test -e PGSQL_DB_1_OWNER=test -e PGSQL_DB_1_POSTGIS=1 "${CI_REGISTRY_IMAGE}:${TAG}"
cleanup_docker=1

echo "Sleeping"
sleep 10

echo "Testing"
docker run --rm --network testnet --entrypoint '' -e PGPASSWORD=test "${CI_REGISTRY_IMAGE}:${TAG}" psql -h test -U test -d test -c "SELECT 1"
echo "Success"
