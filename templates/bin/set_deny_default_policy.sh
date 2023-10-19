#!/bin/bash 
sed -i 's/default_policy = "allow"/default_policy = "deny"/' {{ consul_config_home }}/consul_config.hcl
systemctl restart consul