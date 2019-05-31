#!/bin/bash

USER_POOL_ID = $POOL_ID

aws cognito-idp list-users --user-pool-id ${USER_POOL_ID} |  jq --raw-output '.Users[] | {user: .Username, email: .Attributes[] | select(.Name == email).Value} | map(.) | @csv' >> users.csv

echo "Done."
