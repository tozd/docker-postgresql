Image providing [PostgreSQL](http://www.postgresql.org/) as a service.

Different branches/tags provide different PostgreSQL versions.

You should make sure you mount data volume (`/var/lib/postgresql`) so that you do not
lose database data when you are recreating a container. If a volume is empty, image
will initialize it at the first startup.

The intended use of this image is that it is shared between multiple other services
and that you create databases and users accordingly.

After first run, you can connect to the PostgreSQL as an administrator from the inside
the container, for example, for a container named `postgresql`:

```
$ docker exec -t -i postgresql /bin/bash
> psql -U postgres postgres
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
