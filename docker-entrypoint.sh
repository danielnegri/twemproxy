#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1:0:1}" = '-' ]; then
    set -- nutcracker "$@"
fi

if [ "$1" = 'nutcracker' -a "$(id -u)" = '0' ]; then
    exec su-exec twemproxy "$0" "$@"
fi

exec "$@"
