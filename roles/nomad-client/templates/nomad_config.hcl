# Server specific configuration for "{{ env }}-{{ region }}"
datacenter = "{{ env }}-{{ region }}"
name = "{{ node_name }}"
region = "{{ region }}"
data_dir = "{{ nomad_data }}"

# Addresses
bind_addr = "0.0.0.0"
advertise {
  http = "{{ private_ip_address }}"
  rpc  = "{{ private_ip_address }}"
  serf = "{{ private_ip_address }}"
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}


# Logging Configurations
log_level = "INFO"

# Client Configuration
client {
  enabled = true
  meta {
    public = "{{ public }}"
  }
}

#Enable ACL system
acl {
  enabled = true
}

# Consul integration configuration
consul {
  address = "127.0.0.1:8500"
  token   = "{{ nomad_token }}"
}

# Vault integration configuration
vault {
  enabled = true
  address = "http://{{ vault_server_ip }}:8200"
}