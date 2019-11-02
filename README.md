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

terraform plan

terraform apply -auto-approve
terraform destroy -auto-approve
```
