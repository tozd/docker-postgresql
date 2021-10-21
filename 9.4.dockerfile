FROM registry.gitlab.com/tozd/docker/runit:ubuntu-bionic

EXPOSE 5432/tcp

VOLUME /var/log/postgresql
VOLUME /var/lib/postgresql

ENV PGSQL_ROLE_1_USERNAME=
ENV PGSQL_ROLE_1_PASSWORD=
ENV PGSQL_ROLE_1_FLAGS LOGIN

ENV PGSQL_DB_1_NAME=
ENV PGSQL_DB_1_OWNER=
ENV PGSQL_DB_1_ENCODING UNICODE
ENV PGSQL_DB_1_LC_COLLATE=
ENV PGSQL_DB_1_LC_CTYPE=
ENV PGSQL_DB_1_TEMPLATE=DEFAULT
ENV PGSQL_DB_1_POSTGIS=

RUN apt-get update -q -q && \
 apt-get --yes --force-yes install wget ca-certificates && \
 echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
 wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
 apt-get update -q -q && \
 apt-get --no-install-recommends --yes --force-yes install postgresql-9.4 postgresql-9.4-postgis-2.4 postgresql-9.4-postgis-2.4-scripts && \
 mkdir -m 700 /var/lib/postgresql.orig && \
 mv /var/lib/postgresql/* /var/lib/postgresql.orig/ && \
 echo 'mappostgres postgres postgres' >> /etc/postgresql/9.4/main/pg_ident.conf && \
 echo 'mappostgres root postgres' >> /etc/postgresql/9.4/main/pg_ident.conf && \
 echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.4/main/pg_hba.conf && \
 echo 'hostssl all all 0.0.0.0/0 md5' >> /etc/postgresql/9.4/main/pg_hba.conf && \
 sed -r -i 's/local\s+all\s+postgres\s+peer/local all postgres peer map=mappostgres/' /etc/postgresql/9.4/main/pg_hba.conf && \
 echo "include_dir = 'conf.d'" >> /etc/postgresql/9.4/main/postgresql.conf && \
 mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp && \
 chown postgres:postgres /var/run/postgresql/9.4-main.pg_stat_tmp && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache ~/.npm

COPY ./etc /etc
COPY ./postgresql /etc/postgresql/9.4
