# {{ service_name }}

## English

### Quick Start

```bash
make run
```

### Main Commands

- `make format`
- `make check`
- `make generate`
- `make lint`
- `make test`
- `make test-integration`
- `make build`
- `make mocks`
- `make run`
{% if docker_enabled or pg_enabled or kafka_enabled %}
- `make up`
- `make down`
- `make logs`
{% endif %}

### Module Options (Generated)

- HTTP transport: `GET /healthz`, `GET /readyz`, `GET /v1/ping`{% if http_enabled %} (enabled by default in this scaffold){% else %} (disabled by default in this scaffold){% endif %}
- gRPC transport: Ping method{% if grpc_enabled %} (enabled by default in this scaffold){% else %} (disabled by default in this scaffold){% endif %}
- PostgreSQL module scaffold: {% if pg_enabled %}enabled{% else %}disabled{% endif %}{% if pg_enabled %} (runtime default: disabled, enable via config/env){% endif %}
- Kafka module scaffold: {% if kafka_enabled %}enabled{% else %}disabled{% endif %}{% if kafka_enabled %} (runtime default: disabled, enable via config/env){% endif %}
- Docker app service: {% if docker_enabled %}enabled{% else %}disabled{% endif %}

### Architecture

Default project contract:
- `internal/app` — transport adapters and interceptor layer
- `internal/pkg/model` — domain models and domain errors
- `internal/pkg/service` — business logic
- `internal/pkg/repository` — persistence adapters
- `internal/pkg/infrastructure` — external integrations (Kafka, etc.)
- `internal/pkg/util` — helper/test utility packages

### Configuration

Typed `AppConfig` with precedence:
- `ENV > YAML > defaults`

Local dev helpers:
- `.env.example`
- `config.local.yaml.example`

Common runtime defaults:
- HTTP port: `80`
- gRPC port: `82`
- local non-root fallback in `make run`: `8080/8082`

### Error Handling

Domain errors are mapped centrally:
- `ErrNotFound -> gRPC NotFound / HTTP 404`
- `ErrInvalidArgument -> gRPC InvalidArgument / HTTP 400`
- `ErrUniqueViolation -> gRPC AlreadyExists / HTTP 409`
- `ErrRevisionMismatch -> gRPC FailedPrecondition / HTTP 412`

For gRPC, unary error interceptor is enabled by default and adds optional `ErrorInfo.Reason` with a stable string code.

### How To Add A Use-Case

1. Add domain types/errors in `internal/pkg/model`.
2. Add business logic in `internal/pkg/service/<feature>`.
3. Add transport handlers in `internal/app/<feature>`.
4. Wire dependencies in `cmd/{{ service_name }}/main.go`.
5. Add repository/infrastructure adapters only when needed.

---

## Русский

### Быстрый старт

```bash
make run
```

### Основные команды

- `make format`
- `make check`
- `make generate`
- `make lint`
- `make test`
- `make test-integration`
- `make build`
- `make mocks`
- `make run`
{% if docker_enabled or pg_enabled or kafka_enabled %}
- `make up`
- `make down`
- `make logs`
{% endif %}

### Опции модулей (в этом scaffold)

- HTTP транспорт: `GET /healthz`, `GET /readyz`, `GET /v1/ping`{% if http_enabled %} (включен по умолчанию){% else %} (выключен по умолчанию){% endif %}
- gRPC транспорт: Ping метод{% if grpc_enabled %} (включен по умолчанию){% else %} (выключен по умолчанию){% endif %}
- PostgreSQL модуль (scaffold): {% if pg_enabled %}включен{% else %}выключен{% endif %}{% if pg_enabled %} (runtime по умолчанию выключен, включается через config/env){% endif %}
- Kafka модуль (scaffold): {% if kafka_enabled %}включен{% else %}выключен{% endif %}{% if kafka_enabled %} (runtime по умолчанию выключен, включается через config/env){% endif %}
- Docker app service: {% if docker_enabled %}включен{% else %}выключен{% endif %}

### Архитектура

Базовый контракт проекта:
- `internal/app` — transport adapters и слой interceptor-ов
- `internal/pkg/model` — доменные модели и доменные ошибки
- `internal/pkg/service` — бизнес-логика
- `internal/pkg/repository` — адаптеры хранения
- `internal/pkg/infrastructure` — внешние интеграции (Kafka и т.д.)
- `internal/pkg/util` — вспомогательные/test utility пакеты

### Конфигурация

Типизированный `AppConfig` с приоритетом источников:
- `ENV > YAML > defaults`

Файлы для локальной разработки:
- `.env.example`
- `config.local.yaml.example`

Базовые runtime значения:
- HTTP порт: `80`
- gRPC порт: `82`
- локальный non-root fallback в `make run`: `8080/8082`

### Обработка ошибок

Доменные ошибки маппятся централизованно:
- `ErrNotFound -> gRPC NotFound / HTTP 404`
- `ErrInvalidArgument -> gRPC InvalidArgument / HTTP 400`
- `ErrUniqueViolation -> gRPC AlreadyExists / HTTP 409`
- `ErrRevisionMismatch -> gRPC FailedPrecondition / HTTP 412`

Для gRPC по умолчанию подключен unary error-interceptor с optional `ErrorInfo.Reason` (stable string code).

### Как Добавить Use-Case

1. Добавить доменные типы/ошибки в `internal/pkg/model`.
2. Добавить бизнес-логику в `internal/pkg/service/<feature>`.
3. Добавить transport-обработчики в `internal/app/<feature>`.
4. Связать зависимости в `cmd/{{ service_name }}/main.go`.
5. Добавлять repository/infrastructure адаптеры только при необходимости.
