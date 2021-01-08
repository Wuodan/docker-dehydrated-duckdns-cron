#!/bin/bash

set -e

APP_VERSION=0.7.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker buildx build \
	--platform linux/arm/v6 \
	--tag wuodan/docker-dehydrated-duckdns-cron:"${APP_VERSION}" \
	--tag wuodan/docker-dehydrated-duckdns-cron:latest \
	--build-arg APP_VERSION="${APP_VERSION}" \
	"${DIR}"

docker push wuodan/docker-dehydrated-duckdns-cron:"${APP_VERSION}" 

docker push wuodan/docker-dehydrated-duckdns-cron:latest
