#!/bin/bash
export CONSUL_HTTP_ADDR=http://$(aws ec2 describe-instances --region {{ region }} --filters "Name=tag:Name,Values=consul-{{ env }}" --query 'Reservations[].Instances[].PrivateIpAddress' --output text | awk '{print $1}'):8500
export CONSUL_HTTP_TOKEN=$(aws secretsmanager get-secret-value --secret-id {{ consul_bootstrap_secret_name }} --region {{ region }} | jq -r '.["SecretString"] | fromjson | ."acl-bootsrap-token"')

curl --request GET -H "X-Consul-Token: $CONSUL_HTTP_TOKEN" $CONSUL_HTTP_ADDR/v1/acl/tokens | jq -r '.[] | select(.Description == "Token for Nomad Server") | .SecretID'
