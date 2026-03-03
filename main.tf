# =============================================================================
# TERRAFORM HACKATHON — Запускаем веб-сайт в GCP за 45 минут!
# =============================================================================
# Ваша задача: заполнить все места, помеченные TODO.
# Не меняйте ничего, кроме указанных мест.
# =============================================================================

# TODO 1: Укажите ваш GCP Project ID
# Найти его можно вверху страницы Cloud Console или выполнив:
#   gcloud config get-value project
provider "google" {
  project = "УКАЖИ_СВОЙ_PROJECT_ID"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

# -----------------------------------------------------------------------------
# Ресурс 1: Виртуальная сеть (VPC)
# Этот блок готов — ничего менять не нужно.
# -----------------------------------------------------------------------------
resource "google_compute_network" "vpc_network" {
  name                    = "hackathon-network"
  auto_create_subnetworks = true
}

# -----------------------------------------------------------------------------
# Ресурс 2: Правило файрвола
# Разрешает входящий HTTP-трафик к нашему серверу.
# -----------------------------------------------------------------------------
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    # TODO 2: Укажите номер порта для HTTP-трафика.
    # Подсказка: стандартный порт для HTTP — это...
    ports = ["КАКОЙ_ПОРТ"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"] # Правило применится к машинам с этим тегом
}

# -----------------------------------------------------------------------------
# Ресурс 3: Виртуальная машина (Compute Engine)
# Здесь запустится ваш веб-сервер.
# -----------------------------------------------------------------------------
resource "google_compute_instance" "web_server" {
  name         = "my-awesome-app"
  machine_type = "e2-micro" # Самый маленький и бесплатный тип машины

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      # Наличие этого пустого блока даёт машине публичный IP-адрес
    }
  }

  # TODO 3: Добавьте тег, чтобы правило файрвола применилось к этой машине.
  # Посмотрите на поле target_tags в ресурсе google_compute_firewall выше —
  # тег должен совпадать!
  tags = ["ДОБАВЬ_ТЕГ"]

  # Скрипт выполняется автоматически при первом запуске машины.
  # Он устанавливает Nginx и создаёт главную страницу сайта.
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx

    # TODO 4: Замените "Название Вашей Команды" на настоящее имя вашей команды!
    echo '<html>
    <head><style>
      body { font-family: sans-serif; display: flex; justify-content: center;
             align-items: center; height: 100vh; margin: 0; background: #f0f4f8; }
      .card { background: white; padding: 3rem; border-radius: 1rem;
              box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center; }
      h1 { color: #1a73e8; } p { color: #5f6368; }
    </style></head>
    <body><div class="card">
      <h1>Hello from Terraform! 🚀</h1>
      <p>Deployed by: <strong>Название Вашей Команды</strong></p>
      <p>Infrastructure as Code — это просто!</p>
    </div></body></html>' > /var/www/html/index.html

    systemctl restart nginx
  EOF
}
