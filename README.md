# Terraform Hackathon: Запускаем сайт в GCP за 45 минут

Добро пожаловать! За следующие 45 минут вы развернёте настоящую облачную инфраструктуру в Google Cloud Platform с помощью Terraform и увидите свой сайт в интернете.

## Что мы создадим

```
Интернет
    │
    ▼
[Firewall Rule]  ← разрешает трафик на порт 80
    │
    ▼
[Compute Engine VM]  ← виртуальная машина с Nginx
    │  (внутри VPC Network)
    ▼
"Hello from Team [Ваша команда]!"
```

**3 ресурса = 1 работающий сайт.**

---

## Шаг 0: Откройте Google Cloud Shell

Перейдите по ссылке: **https://shell.cloud.google.com**

> Google Cloud Shell — это терминал прямо в браузере. Там уже установлен Terraform, и вы уже авторизованы в GCP. Никаких дополнительных установок не нужно!

Проверьте, что Terraform работает:
```bash
terraform version
```

---

## Шаг 1: Склонируйте репозиторий

```bash
git clone https://github.com/vbradnitski/terraform-workshop.git
cd terraform-workshop
```

Откройте редактор файлов:
```bash
cloudshell edit main.tf
```

---

## Шаг 2: Ознакомьтесь со структурой проекта

| Файл | Описание |
|------|----------|
| `main.tf` | **Ваша задача** — здесь 4 места, которые нужно заполнить |
| `outputs.tf` | Готов — выведет ссылку на ваш сайт после `apply` |
| `versions.tf` | Готов — указывает версии Terraform и провайдера |
| `CHEATSHEET.md` | Шпаргалка по командам |

---

## Шаг 3: Выполните задания в main.tf

Откройте `main.tf` и найдите все места с `TODO`. Их 4:

### TODO 1 — Укажите Project ID

Найдите ваш Project ID:
```bash
gcloud config get-value project
```

Замените `УКАЖИ_СВОЙ_PROJECT_ID` на реальный ID проекта.

### TODO 2 — Укажите порт для HTTP

В блоке `google_compute_firewall` замените `"КАКОЙ_ПОРТ"` на правильный порт.

<details>
<summary>Подсказка (нажмите, если затрудняетесь)</summary>
HTTP работает на порту <code>80</code>
</details>

### TODO 3 — Добавьте тег к виртуальной машине

Правило файрвола применяется только к машинам, у которых есть определённый тег (`target_tags`). Посмотрите, какой тег стоит в `google_compute_firewall`, и укажите его же в `tags` для виртуальной машины.

### TODO 4 — Впишите имя вашей команды

В `metadata_startup_script` замените `Название Вашей Команды` на имя вашей команды. Это имя появится на сайте!

---

## Шаг 4: Инициализируйте Terraform

```bash
terraform init
```

Terraform скачает провайдер Google Cloud. Вы увидите:
```
Terraform has been successfully initialized!
```

---

## Шаг 5: Проверьте план

```bash
terraform plan
```

Terraform покажет, что он **собирается** создать (ничего ещё не создаётся!). Должно быть `3 to add`.

---

## Шаг 6: Создайте инфраструктуру!

```bash
terraform apply
```

Terraform спросит подтверждение — введите `yes`.

Подождите 1-2 минуты. По завершении вы увидите:

```
Apply complete! Resources: 3 added.

Outputs:

website_url = "http://xx.xx.xx.xx"
```

---

## Шаг 7: Откройте ваш сайт!

Скопируйте `website_url` из вывода и откройте в браузере.

> Если сайт не открывается сразу — подождите ещё 1-2 минуты. Машина только запустилась и устанавливает Nginx.

Также можно посмотреть ссылку в любое время:
```bash
terraform output website_url
```

---

## Шаг 8: Удалите инфраструктуру

Это важный шаг — так вы не тратите деньги на облако после хакатона!

```bash
terraform destroy
```

Введите `yes`. Terraform удалит все 3 ресурса за несколько секунд.

**Вот в чём магия Infrastructure as Code:** создать инфраструктуру и удалить её так же просто, как запустить одну команду.

---

## Бонусные задания (если остаётся время)

1. **Измените HTML**: Обновите текст в `metadata_startup_script`, затем выполните `terraform apply` снова. Что произошло?

2. **Добавьте второй тег**: Добавьте в `tags` машины ещё один тег `["web-server", "hackathon"]` и запустите `terraform plan`. Сколько ресурсов изменится?

3. **Изучите state**: Запустите `cat terraform.tfstate` — это файл, в котором Terraform хранит информацию о созданных ресурсах.

---

## Нужна помощь?

- Смотрите `CHEATSHEET.md` — там описаны частые ошибки и их решения
- Документация Terraform: https://registry.terraform.io/providers/hashicorp/google/latest/docs
