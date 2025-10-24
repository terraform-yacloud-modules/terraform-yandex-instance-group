# Yandex Cloud Instance Group with Secondary Disks

Terraform конфигурация для создания группы виртуальных машин в Yandex Cloud с вторыми дисками.

## Описание

Данная конфигурация создает:
- Группу из 3 виртуальных машин
- Каждая VM имеет второй диск размером 20GB
- Сеть и подсеть для виртуальных машин
- Service account с правами editor
- Настройки масштабирования и развертывания

## Требования

- Terraform 1.0+
- Yandex Cloud аккаунт
- OAuth токен для Yandex Cloud
- SSH ключ для доступа к виртуальным машинам

## Настройка

1. Скопируйте файл `terraform.tfvars.example` в `terraform.tfvars`:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Заполните файл `terraform.tfvars` своими данными:
   ```hcl
   yc_token     = "ваш_oauth_токен"
   yc_cloud_id  = "ваш_cloud_id"  
   yc_folder_id = "ваш_folder_id"
   ```

3. Убедитесь, что у вас есть SSH ключ в `~/.ssh/id_rsa.pub`

## Использование

Инициализация Terraform:
```bash
terraform init
```

Просмотр плана развертывания:
```bash
terraform plan
```

Применение конфигурации:
```bash
terraform apply
```

Уничтожение ресурсов:
```bash
terraform destroy
```

## Выходные данные

После применения конфигурации будут доступны следующие выходные данные:
- `instance_group_id` - ID группы виртуальных машин
- `instance_group_name` - Имя группы
- `instance_count` - Количество инстансов
- `instances_external_ips` - Внешние IP адреса инстансов

## Структура ресурсов

- **yandex_compute_instance_group** - Группа из 3 виртуальных машин
- **yandex_vpc_network** - Виртуальная сеть
- **yandex_vpc_subnet** - Подсеть
- **yandex_iam_service_account** - Service account для ВМ
- **yandex_resourcemanager_folder_iam_member** - Права доступа для SA

## Характеристики виртуальных машин

- Платформа: standard-v3
- Память: 2GB
- Ядра: 2
- Основной диск: 10GB (network-hdd)
- Второй диск: 20GB (network-hdd)
- ОС: Ubuntu 20.04 LTS
- Доступ по SSH через ключ из `~/.ssh/id_rsa.pub`

## Важно

- Убедитесь, что у вас достаточно квот в Yandex Cloud
- Токен и другие чувствительные данные хранятся в переменных
- Для production использования настройте правильные права доступа для service account