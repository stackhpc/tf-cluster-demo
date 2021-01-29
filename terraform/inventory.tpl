[all:vars]
ansible_user=centos
proxy_addr=${fip.address} 
ansible_ssh_common_args='-o ProxyCommand="ssh {{ ansible_user }}@{{ proxy_addr }} -W %h:%p"'
openhpc_cluster_name=${cluster_name}

[cluster:children]
${cluster_name}_login
${cluster_name}_computes

[${cluster_name}_login]
${login.name} ansible_host=${login.network[0].fixed_ip_v4} server_networks='${jsonencode({for net in login.network: net.name => [ net.fixed_ip_v4 ] })}'

[${cluster_name}_computes]
%{ for compute in computes ~}
${compute.name} ansible_host=${compute.network[0].fixed_ip_v4} server_networks='${jsonencode({for net in compute.network: net.name => [ net.fixed_ip_v4 ] })}'
%{ endfor ~}
