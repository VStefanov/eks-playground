unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY

aws sts assume-role --role-arn $EKS_DEPLOYMENT_ROLE --role-session-name eks-admin-deployment-role > temp_creds.json

secret_key=$(jq '.Credentials.SecretAccessKey' temp_creds.json)
access_key=$(jq '.Credentials.AccessKeyId' temp_creds.json)
session_token=$(jq '.Credentials.SessionToken' temp_creds.json)

echo "export AWS_ACCESS_KEY_ID=$access_key"
echo "export AWS_SECRET_ACCESS_KEY=$secret_key"
echo "export AWS_SESSION_TOKEN=$session_token"
echo "export AWS_REGION=eu-west-1"

rm -rf temp_creds.json