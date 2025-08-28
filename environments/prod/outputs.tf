# outputs.tf
output "web_url" {
value = "https://${module.compute.default_hostname}"
}
