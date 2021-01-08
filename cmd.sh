#!/bin/bash

set -e

# make sure the docker volume mountpoints are writable
chmod ugo+w /dehydrated/accounts
chmod ugo+w /dehydrated/certs

# use acme staging for testing: prod blocks on to many registrations or cert requests
if [ -n "${DEBUG}" ]; then
	printf 'Running in test-mode using amce-staging\n'
	printf 'CA="https://acme-staging-v02.api.letsencrypt.org/directory"' > config
fi
# run once at start
/etc/periodic/daily/dehydrated
# re-run daily
crond -f
