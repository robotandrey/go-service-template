# Go Service Template

Reusable Copier template for Go services with optional PostgreSQL, Kafka, and Docker modules.

## English

### Quick Start

1. Generate service (interactive):

```bash
make service TARGET_DIR=./services/users-api
```

2. Generate service (non-interactive):

```bash
make service \
  TARGET_DIR=./services/users-api \
  SERVICE_NAME=users-api \
  MODULE_PATH=github.com/acme/users-api \
  HTTP_ENABLED=true \
  GRPC_ENABLED=true \
  PG_ENABLED=true \
  KAFKA_ENABLED=true \
  KAFKA_PRODUCER_ENABLED=true \
  KAFKA_CONSUMER_ENABLED=false \
  DOCKER_ENABLED=true
```

3. Run generated service:

```bash
cd ./services/users-api
make generate
make mocks
make run
```

### Prerequisites

Required system tools:
- `go`
- `make`

`copier` is auto-installed by `make service` (`uv` first, then `pipx`).
Interactive flow uses native Copier UI.

### Generation Flags

Required:
- `TARGET_DIR`

Core:
- `SERVICE_NAME`
- `MODULE_PATH` (default: `example.com/<service_name>`)
- `HTTP_ENABLED` (default: `false`)
- `GRPC_ENABLED` (default: `true`)

Optional modules:
- `PG_ENABLED` (default: `false`)
- `KAFKA_ENABLED` (default: `false`)
- `KAFKA_PRODUCER_ENABLED` (default: `false`, valid only with `KAFKA_ENABLED=true`)
- `KAFKA_CONSUMER_ENABLED` (default: `false`, valid only with `KAFKA_ENABLED=true`)
- `DOCKER_ENABLED` (default: `false`)

Validation:
- at least one transport must be enabled (`HTTP_ENABLED` or `GRPC_ENABLED`)
- when Kafka is enabled, at least one Kafka mode must be enabled (producer or consumer)

### Runtime Defaults

- Public HTTP: `8080`
- gRPC: `9090`
- Admin/docs HTTP: `8081`

Docs endpoints:
- `GET /docs`
- `GET /swagger.json`
- `GET /openapi/swagger.json`

### Template Contract

Generated service structure:
- `cmd/<service>` — composition root and lifecycle
- `internal/app` — transport adapters and interceptors
- `internal/pkg/model` — domain models and errors
- `internal/pkg/service` — business logic
- `internal/pkg/repository` — PostgreSQL adapters (when enabled)
- `internal/pkg/infrastructure` — Kafka adapters
- `internal/pb/<module-path>/...` — generated proto/gateway/openapi artifacts
- `test/mock` — generated mocks
- `.deploy/config` — local config examples
- `.deploy/docker` — Dockerfile and compose assets
- `.deploy/openapi` — HTTP-only swagger source

Config load priority:
- `ENV > YAML > defaults`

### CI

Root repository includes template matrix CI (`grpc-only`, `http-only`, `dual`, `full`) with:
- `make generate`
- `make mocks`
- `make lint`
- `make test`
- `make build`
- runtime smoke checks for docs and gateway routes

Generated repository includes baseline CI with:
- `make generate`
- `make mocks`
- `make lint`
- `make test`
- `make build`
- OpenAPI and generated layout checks

---

## Русский

### Быстрый старт

1. Сгенерировать сервис (интерактивно):

```bash
make service TARGET_DIR=./services/users-api
```

2. Сгенерировать сервис (неинтерактивно):

```bash
make service \
  TARGET_DIR=./services/users-api \
  SERVICE_NAME=users-api \
  MODULE_PATH=github.com/acme/users-api \
  HTTP_ENABLED=true \
  GRPC_ENABLED=true \
  PG_ENABLED=true \
  KAFKA_ENABLED=true \
  KAFKA_PRODUCER_ENABLED=true \
  KAFKA_CONSUMER_ENABLED=false \
  DOCKER_ENABLED=true
```

3. Запустить сгенерированный сервис:

```bash
cd ./services/users-api
make generate
make mocks
make run
```

### Предварительные требования

Обязательные системные инструменты:
- `go`
- `make`

`copier` ставится автоматически из `make service` (`uv`, затем `pipx`).
Интерактивный сценарий использует стандартный Copier UI.

### Флаги генерации

Обязательный:
- `TARGET_DIR`

Базовые:
- `SERVICE_NAME`
- `MODULE_PATH` (по умолчанию: `example.com/<service_name>`)
- `HTTP_ENABLED` (по умолчанию: `false`)
- `GRPC_ENABLED` (по умолчанию: `true`)

Опциональные модули:
- `PG_ENABLED` (по умолчанию: `false`)
- `KAFKA_ENABLED` (по умолчанию: `false`)
- `KAFKA_PRODUCER_ENABLED` (по умолчанию: `false`, валиден только при `KAFKA_ENABLED=true`)
- `KAFKA_CONSUMER_ENABLED` (по умолчанию: `false`, валиден только при `KAFKA_ENABLED=true`)
- `DOCKER_ENABLED` (по умолчанию: `false`)

Валидации:
- должен быть включен хотя бы один транспорт (`HTTP_ENABLED` или `GRPC_ENABLED`)
- при включенной Kafka должен быть включен producer или consumer

### Runtime defaults

- Public HTTP: `8080`
- gRPC: `9090`
- Admin/docs HTTP: `8081`

Docs endpoints:
- `GET /docs`
- `GET /swagger.json`
- `GET /openapi/swagger.json`

### Контракт шаблона

Структура сгенерированного сервиса:
- `cmd/<service>` — composition root и lifecycle
- `internal/app` — transport adapters и interceptors
- `internal/pkg/model` — доменные модели и ошибки
- `internal/pkg/service` — бизнес-логика
- `internal/pkg/repository` — PostgreSQL-адаптеры (если включены)
- `internal/pkg/infrastructure` — Kafka адаптеры
- `internal/pb/<module-path>/...` — generated proto/gateway/openapi артефакты
- `test/mock` — generated моки
- `.deploy/config` — примеры локального конфига
- `.deploy/docker` — Dockerfile и compose assets
- `.deploy/openapi` — источник swagger для http-only профиля

Приоритет загрузки конфига:
- `ENV > YAML > defaults`

### CI

В корневом репозитории есть template matrix CI (`grpc-only`, `http-only`, `dual`, `full`) с шагами:
- `make generate`
- `make mocks`
- `make lint`
- `make test`
- `make build`
- runtime smoke-проверки docs и gateway роутов

В сгенерированном репозитории есть базовый CI со шагами:
- `make generate`
- `make mocks`
- `make lint`
- `make test`
- `make build`
- проверка OpenAPI и layout generated-артефактов
