#!/bin/sh
set -eu

cd /opt/oversight
exec socat TCP-LISTEN:31909,reuseaddr,fork EXEC:'/run-challenge.sh'
