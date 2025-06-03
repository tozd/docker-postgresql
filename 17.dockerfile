FROM registry.gitlab.com/tozd/docker/dinit:ubuntu-noble

EXPOSE 5432/tcp

VOLUME /var/log/postgresql
VOLUME /var/lib/postgresql

ENV PGSQL_ROLE_1_USERNAME=
ENV PGSQL_ROLE_1_PASSWORD=
ENV PGSQL_ROLE_1_FLAGS=LOGIN

ENV PGSQL_DB_1_NAME=
ENV PGSQL_DB_1_OWNER=
ENV PGSQL_DB_1_ENCODING=UNICODE
ENV PGSQL_DB_1_LC_COLLATE=
ENV PGSQL_DB_1_LC_CTYPE=
ENV PGSQL_DB_1_TEMPLATE=DEFAULT
ENV PGSQL_DB_1_POSTGIS=

ENV LOG_TO_STDOUT=0

RUN apt-get update -q -q && \
  apt-get --yes --force-yes install wget ca-certificates && \
  mkdir -p /usr/share/postgresql-common/pgdg && \
  wget --quiet -O /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
  echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt/ noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  apt-get update -q -q && \
  apt-get --no-install-recommends --yes --force-yes install postgresql-17 postgresql-17-postgis-3 postgresql-17-postgis-3-scripts && \
  mkdir -m 700 /var/lib/postgresql.orig && \
  mv /var/lib/postgresql/* /var/lib/postgresql.orig/ && \
  echo 'mappostgres postgres postgres' >> /etc/postgresql/17/main/pg_ident.conf && \
  echo 'mappostgres root postgres' >> /etc/postgresql/17/main/pg_ident.conf && \
  echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/17/main/pg_hba.conf && \
  echo 'hostssl all all 0.0.0.0/0 md5' >> /etc/postgresql/17/main/pg_hba.conf && \
  sed -r -i 's/local\s+all\s+postgres\s+peer/local all postgres peer map=mappostgres/' /etc/postgresql/17/main/pg_hba.conf && \
  echo "include_dir = 'conf.d'" >> /etc/postgresql/17/main/postgresql.conf && \
  mkdir -p /var/run/postgresql/17-main.pg_stat_tmp && \
  chown postgres:postgres /var/run/postgresql/17-main.pg_stat_tmp && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache ~/.npm

COPY ./etc/service/postgresql /etc/service/postgresql
COPY ./postgresql /etc/postgresql/17
