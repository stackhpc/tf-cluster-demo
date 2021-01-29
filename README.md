
# Installation
```
sudo yum install -y python3
python3 -m venv venv
. venv/bin/activate
pip install -U pip
pip install -r requirements.txt
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
cd terraform
terraform init # this installs the required providers
```

# Use

Modify `terraform/terraform.tfvars` as appropriate for your cloud.

To create a cluster:
```
terraform apply
```
