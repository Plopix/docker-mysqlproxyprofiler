#!/usr/bin/env bash

cp /usr/src/mp_template.conf /etc/mp.conf
cp /usr/src/debug_template.lua /etc/debug.lua
chmod 600 /etc/mp.conf

if [ "${USE_NO_CACHE}" == '1' ];
then
    sed -i s/use_sql_no_cache\ \=\ 0/use_sql_no_cache\ =\ 1/g /etc/debug.lua
fi

sed -i s/ENVBACKEND/${BACKEND}/g /etc/mp.conf

ldconfig

exec "$@"
