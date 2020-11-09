FROM registry.gitlab.com/tozd/docker/runit:ubuntu-trusty

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
 apt-get --no-install-recommends --yes --force-yes install postgresql-9.3 postgresql-9.3-postgis-2.1 && \
 mkdir -m 700 /var/lib/postgresql.orig && \
 mv /var/lib/postgresql/* /var/lib/postgresql.orig/ && \
 echo 'mappostgres postgres postgres' >> /etc/postgresql/9.3/main/pg_ident.conf && \
 echo 'mappostgres root postgres' >> /etc/postgresql/9.3/main/pg_ident.conf && \
 echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf && \
 echo 'hostssl all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf && \
 sed -r -i 's/local\s+all\s+postgres\s+peer/local all postgres peer map=mappostgres/' /etc/postgresql/9.3/main/pg_hba.conf && \
 echo "include_dir = 'conf.d'" >> /etc/postgresql/9.3/main/postgresql.conf && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache ~/.npm

COPY ./etc /etc
COPY ./postgresql /etc/postgresql/9.3
