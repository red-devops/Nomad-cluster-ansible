#!/bin/bash 
export CONSUL_HTTP_ADDR=http://localhost:8500
sleep 5 #Waiting for the election of a leader
TOKEN=$(/home/consul/bin/consul acl bootstrap -format=json | jq -r '.SecretID')
if [ -z "$TOKEN" ]; then
    echo "Empty TOKEN abort script."
    exit 0
fi
aws secretsmanager create-secret --name {{ consul_bootstrap_secret_name }} --description "Consul {{ env }} ACL Bootstrap Token (Global Management)" --secret-string '{"acl-bootsrap-token":"'"$TOKEN"'"}'  --region {{ region }}
if [ $? -eq 0 ]; then
    echo "Created a new secret."
    exit 0
else
    echo "Failed to create a new secret. Trying to update the existing one..."
    aws secretsmanager update-secret --secret-id {{ consul_bootstrap_secret_name }} --description  "Consul {{ env }} ACL Bootstrap Token (Global Management)" --secret-string '{"acl-bootsrap-token":"'"$TOKEN"'"}' --region {{ region }}
    if [ $? -eq 0 ]; then
        echo "Overwrote the existing secret."
        exit 0
    else
        echo "An error occurred while creating or overwriting the secret."
        exit 1
    fi
fi
systemctl restart consul
