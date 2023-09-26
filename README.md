### Hexlet tests and linter status:
[![Actions Status](https://github.com/azeos1101/devops-for-programmers-project-77/workflows/hexlet-check/badge.svg)](https://github.com/azeos1101/devops-for-programmers-project-77/actions)


Тестовое приложение расположено по адресу: https://terra.pimbi.icu/

## Комментарии к задачам проекта
Шаг 6. Мониторинг с использованием Freshping сейчас недоступен, так как они закрыли доступ для бесплатных аккаунтов.
Мониторинг настроил на сервисе Pingdom


## Разворачивание системы
Для запуска проекта необходимо положить файл `password_file` в корневую директорию проекта,
`secret.auto.tfvars` в директорию `terrafrom` и выполнить команды:
```bash
# Установить зависимости Terraform, развернуть инфраструктуру, выполнить инициализацию инфраструктуры
# Процесс обновления и установки пакетов на новые сервера может занять долгое время.
# Дождаться полго выполнения всех задач
make terra_run

# Установка зависимостей, деплой и установка datadog агента на удаленные машины
make ansible_run
```

## Дополнительные команды

### Утилиты

```bash
# Автоформатирование конфига Terraform
make terra_format

# Json c полной конфигурацией inventory
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

### Playbooks
```bash
# Обновление кеша apt, установака зависимостей
make install_packages

# Деплой приложения. Пересоздает докер контейнер на основе последней версии образа из docker hub при каждом запуске.
# Выполняется последовательно на каждом хосте, для избежания конфлита между хостами при выполнении миграций
make deploy

# Устанавлдивает и настраивает datadog агент
make datadog
```
