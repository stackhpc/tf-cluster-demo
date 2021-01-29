compute_names = ["compute-0", "compute-1"]
cluster_name  = "ohpctest" # don't put dashes (creates invalid ansible group names) or underscores (creates hostnames which get mangled) in this
key_pair = "steveb-local"
external_network = "internet"

login_image = "CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64"
login_flavor = "frankfurter"

compute_image = "CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64"
compute_flavor = "frankfurter"
