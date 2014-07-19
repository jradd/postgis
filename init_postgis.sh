#!/bin/bash

GEOGRAPHY=0
POSTGIS_SQL=postgis.sql

if [ -d "/usr/share/postgresql/9.3/contrib/postgis-2.1" ]
then
    POSTGIS_SQL_PATH=/usr/share/postgresql/9.3/contrib/postgis-2.1
    GEOGRAPHY=1
fi

createdb -E UTF8 template_postgis && \
( createlang -d template_postgis -l | grep plpgsql || createlang -d template_postgis plpgsql ) && \
psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';" && \
psql -d template_postgis -f $POSTGIS_SQL_PATH/$POSTGIS_SQL && \
psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql && \
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;" && \
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"

if [ $GEOGRAPHY -eq 1 ]
then
    psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
fi
