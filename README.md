# tozd/postgresql

<https://gitlab.com/tozd/docker/postgresql>

Available as:

- [`tozd/postgresql`](https://hub.docker.com/r/tozd/postgresql)
- [`registry.gitlab.com/tozd/docker/postgresql`](https://gitlab.com/tozd/docker/postgresql/container_registry)

## Image inheritance

[`tozd/base`](https://gitlab.com/tozd/docker/base) ← [`tozd/dinit`](https://gitlab.com/tozd/docker/dinit) ← `tozd/postgresql`

## Tags

- `9.3`: PostgreSQL 9.3
- `9.4`: PostgreSQL 9.4
- `9.5`: PostgreSQL 9.5
- `9.6`: PostgreSQL 9.6
- `10`: PostgreSQL 10
- `11`: PostgreSQL 11
- `12`: PostgreSQL 12
- `13`: PostgreSQL 13
- `14`: PostgreSQL 14
- `15`: PostgreSQL 15

## Volumes

- `/var/log/postgresql`: Log files when `LOG_TO_STDOUT` is not set to `1`.
- `/var/lib/postgresql`: Persist this volume to not lose state.

## Variables

To optionally initialize at the first startup:

- `PGSQL_ROLE_1_USERNAME`: Username of a user to create.
- `PGSQL_ROLE_1_PASSWORD`: Password for the created user.
- `PGSQL_ROLE_1_FLAGS`: Any flags at user creation. Default is `LOGIN`.
- `PGSQL_DB_1_NAME`: Name of a database to be created.
- `PGSQL_DB_1_OWNER`: Username of the owner of the database. Must be set for database creation to work.
- `PGSQL_DB_1_ENCODING`: Encoding for the database. Default is `UNICODE`.
- `PGSQL_DB_1_LC_COLLATE`: Collation order for the database. Default is empty.
- `PGSQL_DB_1_LC_CTYPE`: Character classification for the database. Default is empty.
- `PGSQL_DB_1_TEMPLATE: Name of the template from which to create the new database. Default is `DEFAULT`.
- `PGSQL_DB_1_POSTGIS`: If set, PostGIS will be installed in the database.

Other:

- `LOG_TO_STDOUT`: If set to `1` output logs to stdout (retrievable using `docker logs`) instead of log volumes.

## Ports

- `5432/tcp`: Port on which PostgreSQL listens.

## Description

Image providing [PostgreSQL](http://www.postgresql.org/) SQL server.

Different Docker tags provide different PostgreSQL versions.

You should make sure you mount data volume (`/var/lib/postgresql`) so that you do not
lose database data when you are recreating a container. If a volume is empty, image
will initialize it at the first startup.

If you are extending this image, you can add a script `/etc/service/postgresql/run.initialization`
which will be run at a container startup, after the container is initialized, but before the
PostgreSQL daemon is run.

When `LOG_TO_STDOUT` is set to `1`, Docker image logs output to stdout and stderr. All stdout output is JSON.

There are two ways to use this image. As a database which is shared between multiple
other services and that you create databases and users accordingly. Or as a database
just for one user/app.

### Multiple users

After first run, you can connect to the PostgreSQL as an administrator from the inside
the container, for example, for a container named `postgresql`:

```
$ docker exec -t -i postgresql /bin/bash
$ psql -U postgres postgres
```

You can create users:

```
$ createuser -U postgres -DRS -PE <USERNAME>
```

You can create a database:

```
$ createdb -U postgres -O <USERNAME> <DBNAME>
```

You can install PostGIS into your database by connecting to it and running:

```
> CREATE EXTENSION postgis;
```

You can backup a database from outside the container:

```
$ docker exec postgresql pg_dump -Fc -U postgres <DBNAME> > /var/backups/<DBNAME>.pgdump
```

You can restore a database from outside the container:

```
$ cat /var/backups/<DBNAME>.pgdump | docker exec -i postgresql pg_restore -Fc -U postgres -d <DBNAME>
```

### Single user

When data volume is initialized at the first startup, you can instruct the image to
automatically create an user and/or a database by passing environment variables to a
container.

## GitHub mirror

There is also a [read-only GitHub mirror available](https://github.com/tozd/docker-postgresql),
if you need to fork the project there.
