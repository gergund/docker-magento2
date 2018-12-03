#!/bin/bash

sed -i "s/{VARNISH_BACKEND_HOST}/$VARNISH_BACKEND_HOST/g" /etc/varnish/default.vcl
sed -i "s/{VARNISH_PURGE_HOST}/$VARNISH_PURGE_HOST/g" /etc/varnish/default.vcl

echo -n "Executing Arguments..."
exec "$@"
