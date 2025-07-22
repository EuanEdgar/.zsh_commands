#!/bin/bash

timeout=30
interval=1
elapsed=0

while ! command docker info >/dev/null 2>&1; do
    if [ $elapsed -ge $timeout ]; then
        echo "Docker daemon did not start within $timeout seconds." >&2
        exit 1
    fi
    sleep $interval
    elapsed=$((elapsed + interval))
done

exit 0
