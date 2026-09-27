# Multi-Service Node.js E-Commerce Deployment

This repository completes the HeroVired assignment **Deploy a Multi-Service Node.js E-commerce Application Using Terraform and Docker**. It containerizes the prescribed [AtharvaAI/E-CommerceStore](https://github.com/AtharvaAI/E-CommerceStore) application into five public Docker images and provisions an Ubuntu EC2 host, VPC, public subnet, Internet Gateway, route table, and least-access security group with Terraform.

## Architecture

```text
Internet :80
    |
    v
Frontend (React + Nginx)
    |-- /user/*    -> User Service    :3001
    |-- /product/* -> Product Service :3002
    |-- /cart/*    -> Cart Service    :3003
    `-- /order/*   -> Order Service   :3004
                              |
                              v
                         MongoDB :27017
```

Only port 80 is public. Backend ports remain inside the Docker bridge network; the AWS security group also defines self-referenced TCP 3001–3004 rules for internal service traffic.

## Public Docker Hub images

- `tabrezajazdc/ecommerce-user:latest`
- `tabrezajazdc/ecommerce-product:latest`
- `tabrezajazdc/ecommerce-cart:latest`
- `tabrezajazdc/ecommerce-order:latest`
- `tabrezajazdc/ecommerce-frontend:latest`

Each backend image exposes its assigned port and returns a required sample response from `/`. Every image includes a health check and runs as a non-root user where supported.

## Local build and test

Prerequisite: Docker Desktop.

```powershell
./scripts/build-and-test.ps1
```

The script builds all five images, starts MongoDB and the five services, waits for healthy containers, verifies all five responses through Nginx, prints container status, and removes the test stack and volume.

Expected checks:

```text
PASS Frontend: Frontend is Live
PASS User: User Service Running
PASS Product: Product Service Running
PASS Cart: Cart Service Running
PASS Order: Order Service Running
```

## Push images

Authenticate with `docker login`, then run:

```powershell
./scripts/push-images.ps1
```

## Terraform deployment

1. Authenticate the AWS CLI.
2. Create or select an EC2 key pair.
3. Copy `terraform/terraform.tfvars.example` to the ignored `terraform/terraform.tfvars`.
4. Restrict `admin_cidr` to your current public IPv4 `/32` and set `key_name`.
5. Deploy:

```powershell
terraform -chdir=terraform init
terraform -chdir=terraform plan -out=assignment.tfplan
terraform -chdir=terraform apply assignment.tfplan
```

EC2 user-data installs Docker from Docker's signed Ubuntu repository, pulls all five public images plus MongoDB, starts them with health dependencies, and writes `/opt/ecommerce/BOOTSTRAP_COMPLETE` after the frontend becomes healthy.

## Verify

```powershell
$url = terraform -chdir=terraform output -raw frontend_url
./scripts/verify-deployment.ps1 -BaseUrl $url
```

Terraform also outputs the public IP, DNS name, and all five health URLs.

## Cost-safe cleanup

The assignment uses one `t3.small` instance with a 20 GiB encrypted gp3 volume. Destroy it immediately after evidence collection:

```powershell
terraform -chdir=terraform destroy -auto-approve
```

## Security

- SSH is restricted to the supplied administrator CIDR.
- Only HTTP port 80 is public.
- Backend and MongoDB ports are not mapped to the host.
- EC2 requires IMDSv2 and uses encrypted, delete-on-termination storage.
- Terraform state, plans, credentials, environment files, and real variable files are ignored.
- JWT material is generated on the EC2 host and stored mode `0600`.

## Submission

- Implementation report: `docs/Implementation_Report.html`
- Screenshots: `docs/screenshots/`
- Repository link: `SUBMISSION_LINK.txt`
