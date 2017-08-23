#! /bin/bash -e

nc --send-only localhost 5044 < /dev/null && exit 0 || exit 1