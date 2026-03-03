# Шпаргалка по Terraform

## Основные команды

| Команда | Что делает |
|---------|-----------|
| `terraform init` | Инициализирует проект, скачивает провайдеры |
| `terraform plan` | Показывает, что изменится (ничего не создаёт!) |
| `terraform apply` | Создаёт/изменяет инфраструктуру |
| `terraform apply -auto-approve` | То же самое, без подтверждения |
| `terraform destroy` | **Удаляет всю инфраструктуру** |
| `terraform output` | Показывает значения output-переменных |

## Полезные команды GCP

```bash
# Узнать ваш Project ID
gcloud config get-value project

# Посмотреть запущенные виртуальные машины
gcloud compute instances list

# SSH на вашу машину (если понадобится)
gcloud compute ssh my-awesome-app --zone=europe-west1-b
```

## Синтаксис Terraform (HCL)

```hcl
# Комментарий

# Ресурс: что создать
resource "тип_ресурса" "локальное_имя" {
  аргумент = "значение"
}

# Ссылка на другой ресурс
resource "google_compute_instance" "vm" {
  network = google_compute_network.vpc_network.name
  #        ^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^^^ ^^^^
  #        тип_ресурса              локальное   атрибут
  #                                 имя
}
```

## Частые ошибки

**Error: Invalid provider configuration**
→ Проверьте, что заменили `УКАЖИ_СВОЙ_PROJECT_ID` на реальный project_id

**Error: googleapi: Error 403**
→ Убедитесь, что вы в Google Cloud Shell (авторизация автоматическая)

**Сайт не открывается сразу после `apply`**
→ Подождите 1-2 минуты — машина запускается и устанавливает Nginx

**Error: Error waiting for instance to create**
→ Проверьте, что в `tags` стоит тот же тег, что в `target_tags` файрвола
