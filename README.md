Image providing [PostgreSQL](http://www.postgresql.org/) as a service.

Different Docker tags provide different PostgreSQL versions.

You should make sure you mount data volume (`/var/lib/postgresql`) so that you do not
lose database data when you are recreating a container. If a volume is empty, image
will initialize it at the first startup.

The intended use of this image is that it is shared between multiple other services
and that you create databases and users accordingly.

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

If you are extending this image, you can add a script `/etc/service/postgresql/run.initialization`
which will be run at a container startup, after the container is initialized, but before the
PostgreSQL daemon is run.

When data volume is initialized at the first startup, you can instruct the image to automatically
create an user and/or a database by passing environment variables to a container:

* `PGSQL_ROLE_1_USERNAME` - username of a user to create
* `PGSQL_ROLE_1_PASSWORD` - password for the created user
* `PGSQL_ROLE_1_FLAGS` – any flags at user creation, by default `LOGIN`
* `PGSQL_DB_1_NAME` – name of a database to be created
* `PGSQL_DB_1_OWNER` – username of the owner of the database, must be set for database creation to work
* `PGSQL_DB_1_ENCODING` – encoding for the database, by default `UNICODE`
* `PGSQL_DB_1_LC_COLLATE` – collation order for the database, by default empty
* `PGSQL_DB_1_LC_CTYPE` – character classification for the database, by default empty
* `PGSQL_DB_1_TEMPLATE` – name of template from which to create the new database, by default `DEFAULT`
* `PGSQL_DB_1_POSTGIS` – if set, PostGIS will be installed in the database
