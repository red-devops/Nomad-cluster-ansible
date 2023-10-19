#!/bin/bash 
export NOMAD_ADDR=http://localhost:4646
sleep 20 #Waiting for the election of a leader
TOKEN=$(/home/nomad/bin/nomad acl bootstrap -json | jq -r '.SecretID')
if [ -z "$TOKEN" ]; then
    echo "Empty TOKEN abort script."
    exit 0
fi
aws secretsmanager create-secret --name {{ nomad_bootstrap_secret_name }} --description "Nomad {{ env }} ACL Bootstrap Token (Global Management)" --secret-string '{"acl-bootsrap-token":"'"$TOKEN"'"}'  --region {{ region }}
if [ $? -eq 0 ]; then
    echo "Created a new secret."
    exit 0
else
    echo "Failed to create a new secret. Trying to update the existing one..."
    aws secretsmanager update-secret --secret-id {{ nomad_bootstrap_secret_name }} --description  "Nomad {{ env }} ACL Bootstrap Token (Global Management)" --secret-string '{"acl-bootsrap-token":"'"$TOKEN"'"}' --region {{ region }}
    if [ $? -eq 0 ]; then
        echo "Overwrote the existing secret."
        exit 0
    else
        echo "An error occurred while creating or overwriting the secret."
        exit 1
    fi
fi
systemctl restart nomad