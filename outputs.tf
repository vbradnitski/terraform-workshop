output "website_url" {
  description = "Ссылка на ваше приложение"
  value       = "http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}"
}

output "instance_name" {
  description = "Имя созданной виртуальной машины"
  value       = google_compute_instance.web_server.name
}
