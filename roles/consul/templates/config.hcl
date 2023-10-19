# Main
server = false
datacenter = "{{ env }}-{{ region }}"
domain = "consul"
node_name = "{{ node_name }}-{{ private_ip_address }}"
rejoin_after_leave = true
leave_on_terminate = true

# Logging
log_level = "INFO"

# Data persistence
data_dir = "{{ nomad_data }}"

# Networkig
client_addr = "127.0.0.1"
bind_addr = "{{ private_ip_address }}"

# Join other Consul agents
retry_join = [ "provider=aws tag_key=function tag_value=consul-server region={{ region }}" ]

# Ports
ports {
  grpc      = 8502
  http      = 8500
  dns       = 8600
}

## ACL configuration
acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens {
    agent = "{{ consul_token }}"
  }
}

# Gossip encryption
encrypt = "{{ keygen }}"