# Terraform Web Platform (Azure)


Beginner-friendly, module-based Terraform template. Creates dev and prod environments with networking, compute (App Service + autoscale), and optional database.


## Quickstart
1. `az login`
2. `cd environments/dev && terraform init`
3. `terraform apply -var-file=terraform.tfvars`
4. `terraform output web_url`


## Modules
- networking: VNet + subnets
- compute: App Service Plan + Web App
- database: PostgreSQL Flexible Server


## Clean up
`terraform destroy -var-file=terraform.tfvars`


## Summary
- module / compute = where your web app code runs (App Service, Plan, autoscaling)
- module/networking = where it connects(VNet, subnets, firewall)
- module/database = where it stores data (SQL, Cosmos, Postgres)

## Keep in mind
- autoscale_enabled = true → turns on autoscaling.

- autoscale_min = 1 → your app always keeps at least 1 instance running.

- autoscale_default = 1 → Terraform will start with 1 instance.

- autoscale_max = 3 → can scale up to 3 instances if demand is high.

- cpu_scale_out_threshold = 70 → if average CPU usage goes above 70%, Azure App Service will add more instances.

- cpu_scale_in_threshold = 30 → if CPU usage drops below 30%, it will scale back down.

- scale_cooldown = 5 → 5 minutes between scale events to avoid “flapping.”