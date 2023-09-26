### Hexlet tests and linter status:
[![Actions Status](https://github.com/azeos1101/devops-for-programmers-project-77/workflows/hexlet-check/badge.svg)](https://github.com/azeos1101/devops-for-programmers-project-77/actions)


Тестовое приложение расположено по адресу: https://terra.pimbi.icu/

## Комментарии к задачам проекта
Шаг 6. Мониторинг с использованием Freshping сейчас недоступен, так как они закрыли доступ для бесплатных аккаунтов.
Мониторинг настроил на сервисе Pingdom


## Секреты
Для запуска проекта необходимо положить файл `password_file` в корневую директорию проекта
Файл `secret.auto.tfvars` в директорию `terrafrom`.
`secret` должен содержать следующие переменные:
```ruby
do_token        = "dop_v1_some_token"
datadog_api_key = "some_api_token"
datadog_app_key = "some_app_token"
```

## Разворачивание системы
```bash
# Установить зависимости Terraform, развернуть инфраструктуру, выполнить инициализацию инфраструктуры
# Процесс обновления и установки пакетов на новые сервера может занять долгое время.
# Дождаться полго выполнения всех задач
make terra_run

# Установка зависимостей, деплой и установка datadog агента на удаленные машины
make ansible_run
```

## Дополнительные команды

### Деплой приложения
```bash
make deploy
```

### Утилиты

```bash
# Автоформатирование конфига Terraform
make terra_format

# Запуск планирования Terraform без применения
make terra_plan

# Json c полной конфигурацией inventory для Ansible
make inventory_list

# ping всех хостов из inventory
make ping
```

### Работа секретами
```bash
# Расшифровка файла с секретами для удобного редактирвоания
make vault_decrypt

# Шифрование файла с секретами после редактирвоания
make vault_encrypt

# Просмотр секретов
make vault_secrets
```

