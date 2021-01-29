[all:vars]
ansible_user=centos
proxy_addr={fip.address} 
ansible_ssh_common_args='-o ProxyCommand="ssh {{ ansible_user }}@{{ proxy_addr }} -W %h:%p"'
openhpc_cluster_name=${cluster_name}

[${cluster_name}_login]
${login.name} ansible_host=${login.network[0].fixed_ip_v4} server_networks='${jsonencode({for net in login.network: net.name => [ net.fixed_ip_v4 ] })}'

[${cluster_name}_compute]
%{ for compute in computes ~}
${compute.name} ansible_host=${compute.network[0].fixed_ip_v4} server_networks='${jsonencode({for net in compute.network: net.name => [ net.fixed_ip_v4 ] })}'
%{ endfor ~}

[cluster_login:children]
${cluster_name}_login

# NOTE: This is hardcoded in the tests role
[cluster_compute:children]
${cluster_name}_compute

[login:children]
cluster_login

[computes:children]
cluster_compute

[cluster:children]
login
computes
