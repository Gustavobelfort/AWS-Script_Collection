#!/bin/bash
 
USER_POOL_ID = $POOL_ID
AWS_PROFILE = $AWS_PROFILE

RUN=1

until [ $RUN -eq 0 ] ; do
echo "Listing users"

USERS=`aws --profile ${AWS_PROFILE} cognito-idp --region us-east-1 list-users  --user-pool-id ${USER_POOL_ID} `
echo ${USERS} >> users.json

FINAL=`jq -r '(.Users[] | "\(.Username)")' users.json`
echo ${FINAL} >> final.json

if [ ! "x$FINAL" = "x" ] ; then
    for user in $(<final.json); do
		echo "Deleting user $user"
        echo "passou2"
		aws --profile ${AWS_PROFILE} cognito-idp admin-delete-user --user-pool-id ${USER_POOL_ID} --username ${user}
		echo "Result code: $?"
		echo "Done"
	done
else
	echo "Done, no more users"
	RUN=0
fi

done
