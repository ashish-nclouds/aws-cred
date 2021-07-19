#!/bin/sh

role_arn=$ROLE_ARN
role_session_name=$ROLE_SESSION_NAME
duration=${DURATION_SECONDS:-3600}

aws_access_key=$AWS_ACCESS_KEY_ID
aws_secret_key=$AWS_SECRET_ACCESS_KEY

aws configure set default.region us-east-1
aws configure set aws_access_key_id $aws_access_key
aws configure set aws_secret_access_key $aws_secret_key

creds=$(aws sts assume-role \
  --role-arn $role_arn \
  --role-session-name $role_session_name \
  --duration-seconds $duration)

echo $creds

aws_access_key_id=$(echo $creds | jq -r '.Credentials.AccessKeyId')
aws_secret_access_key=$(echo $creds | jq -r '.Credentials.SecretAccessKey')
aws_session_token=$(echo $creds | jq -r '.Credentials.SessionToken')

echo "Before Mask"

echo ::add-mask::$aws_access_key_id
echo ::add-mask::$aws_secret_access_key
echo ::add-mask::$aws_session_token

echo "Executing  set-output"

echo ::set-output name=AWS_ACCESS_KEY_ID::$aws_access_key_id
echo ::set-output name=AWS_SECRET_ACCESS_KEY::$aws_secret_access_key
echo ::set-output name=AWS_SESSION_TOKEN::$aws_session_token

echo "After set-output"
