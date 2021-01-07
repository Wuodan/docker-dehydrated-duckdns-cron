#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker buildx build --platform linux/arm/v6 --tag wuodan/docker-dehydrated-duckdns-cron "${DIR}"
