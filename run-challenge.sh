#!/bin/sh
set -eu

cd /opt/oversight
exec /opt/glibc-2.27/lib/x86_64-linux-gnu/ld-2.27.so \
    --library-path /opt/oversight:/opt/glibc-2.27/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu:/lib64 \
    /opt/oversight/oversight
