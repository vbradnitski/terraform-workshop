# output "website_url" {
#   description = "Link to access the web server"
#   value       = "http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}"
# }
#
# output "instance_name" {
#   description = "Name of the web server instance"
#   value       = google_compute_instance.web_server.name
# }
