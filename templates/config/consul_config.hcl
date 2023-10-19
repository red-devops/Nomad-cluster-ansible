# Server specific configuration for "{{ env }}-{{ region }}"
datacenter = "{{ env }}-{{ region }}"
node_name = "{{ node_name }}-{{ private_ip_address }}"
server = true
bootstrap_expect = 3
data_dir = "/home/consul/data"
log_level = "INFO"
enable_syslog = true

# Addresses
client_addr = "0.0.0.0"
bind_addr = "{{ private_ip_address }}"

# ACL configuration
acl = {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true
}

# UI configuration
ui_config {
  enabled = true
}

# Join other Consul agents
retry_join = [ "provider=aws tag_key=function tag_value=consul-server region={{ region }}" ]

# Gossip encryption
encrypt = "{{ keygen_var }}"
