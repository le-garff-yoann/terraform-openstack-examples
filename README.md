## Terraform OpenStack examples

### tl;dr

```bash
cd lb-2w/

export \
    OS_AUTH_URL=https://openstack.my.domain/identity \
    OS_USERNAME=myuser \
    OS_PASSWORD=mypassword \
    OS_TENANT_NAME=mytenant

terraform init

terraform plan -out=$OS_TENANT_NAME.tfplan
terraform apply $OS_TENANT_NAME.tfplan

terraform plan -destroy -out=$OS_TENANT_NAME.tfplan
terraform apply $OS_TENANT_NAME.tfplan
```
