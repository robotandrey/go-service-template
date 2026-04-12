# Go Service Template

Reusable Copier-based template for creating Go services with optional PostgreSQL, Kafka, and Docker modules.

## English

### Quick Start

1. Generate a service interactively:

```bash
make service TARGET_DIR=./services/users-api
```

2. Or generate in non-interactive mode:

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
make run
```

### Prerequisites

Required system tools:
- `go`
- `make`

`copier` is auto-installed by `make service` (`uv` first, then `pipx`).

Generated service tools are auto-installed by make targets into local `./bin`:
- `golangci-lint`
- `buf` (when gRPC enabled)
- `protoc-gen-go` (when gRPC enabled)
- `protoc-gen-go-grpc` (when gRPC enabled)
- `goose` (when PostgreSQL enabled)

### Generation Flags

Required:
- `TARGET_DIR`

Core:
- `SERVICE_NAME`
- `MODULE_PATH`
- `HTTP_ENABLED` (default: `false`)
- `GRPC_ENABLED` (default: `true`)

Optional modules:
- `PG_ENABLED` (default: `false`)
- `KAFKA_ENABLED` (default: `false`)
- `KAFKA_PRODUCER_ENABLED` (default: `false`, valid only with `KAFKA_ENABLED=true`)
- `KAFKA_CONSUMER_ENABLED` (default: `false`, valid only with `KAFKA_ENABLED=true`)
- `DOCKER_ENABLED` (default: `false`)

Note:
- PG/Kafka flags add module scaffold files.
- Runtime PG/Kafka are disabled by default in generated config; enable with env or `config.local.yaml`.

Validation:
- at least one transport must be enabled (`HTTP_ENABLED` or `GRPC_ENABLED`)
- when Kafka is enabled, at least one Kafka mode must be enabled (producer or consumer)

### Architecture Contract

Generated service follows this base structure:
- `internal/app` — transport adapters and interceptor layer
- `internal/pkg/model` — domain models and domain errors
- `internal/pkg/service` — business logic
- `internal/pkg/repository` — persistence adapters
- `internal/pkg/infrastructure` — external integrations
- `internal/pkg/util` — helpers and test utilities

Default vertical slice example is `ping` (`model -> service -> app`).
When gRPC is enabled, generated service includes unary error interceptor.
When HTTP is enabled, generated service exposes `GET /healthz`, `GET /readyz`, `GET /v1/ping`.

### Generated Service Commands

- `make format`
- `make check`
- `make generate`
- `make lint`
- `make test`
- `make test-integration`
- `make build`
- `make mocks`
- `make run`
- `make up` / `make down` / `make logs` (when Docker/PG/Kafka compose stack is present)

### Configuration Model

Generated service uses typed `AppConfig`:
- sources precedence: `ENV > YAML > defaults`
- optional local files: `.env.local`, `.env`, `config.local.yaml`
- startup-only load (no runtime reload)

### CI

Generated repository includes GitHub Actions workflow with:
- `make generate`
- `make lint`
- `make test`
- `make build`
- optional compose config check when `docker-compose.yml` exists

---

## Русский

### Быстрый старт

1. Сгенерировать сервис в интерактивном режиме:

```bash
make service TARGET_DIR=./services/users-api
```

2. Или сгенерировать без вопросов (неинтерактивно):

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
make run
```

### Предварительные требования

Обязательные системные инструменты:
- `go`
- `make`

`copier` ставится автоматически из `make service` (`uv`, затем `pipx`).

Инструменты в сгенерированном сервисе ставятся make-целями автоматически в `./bin`:
- `golangci-lint`
- `buf` (если включен gRPC)
- `protoc-gen-go` (если включен gRPC)
- `protoc-gen-go-grpc` (если включен gRPC)
- `goose` (если включен PostgreSQL)

### Флаги генерации

Обязательный:
- `TARGET_DIR`

Базовые:
- `SERVICE_NAME`
- `MODULE_PATH`
- `HTTP_ENABLED` (по умолчанию `false`)
- `GRPC_ENABLED` (по умолчанию `true`)

Опциональные модули:
- `PG_ENABLED` (по умолчанию `false`)
- `KAFKA_ENABLED` (по умолчанию `false`)
- `KAFKA_PRODUCER_ENABLED` (по умолчанию `false`, валиден только при `KAFKA_ENABLED=true`)
- `KAFKA_CONSUMER_ENABLED` (по умолчанию `false`, валиден только при `KAFKA_ENABLED=true`)
- `DOCKER_ENABLED` (по умолчанию `false`)

Важно:
- флаги PG/Kafka добавляют scaffold-файлы модулей;
- в runtime PG/Kafka по умолчанию выключены в сгенерированном конфиге, включаются через env или `config.local.yaml`.

Валидации:
- должен быть включен хотя бы один транспорт (`HTTP_ENABLED` или `GRPC_ENABLED`)
- если Kafka включен, должен быть включен producer или consumer

### Архитектурный Контракт

Сгенерированный сервис использует базовую структуру:
- `internal/app` — transport adapters и interceptor layer
- `internal/pkg/model` — доменные модели и доменные ошибки
- `internal/pkg/service` — бизнес-логика
- `internal/pkg/repository` — адаптеры хранения
- `internal/pkg/infrastructure` — внешние интеграции
- `internal/pkg/util` — helpers/test utilities

Эталонный вертикальный срез по умолчанию: `ping` (`model -> service -> app`).
Если включен gRPC, в сервисе по умолчанию подключается unary error-interceptor.
Если включен HTTP, сервис по умолчанию поднимает `GET /healthz`, `GET /readyz`, `GET /v1/ping`.

### Команды сгенерированного сервиса

- `make format`
- `make check`
- `make generate`
- `make lint`
- `make test`
- `make test-integration`
- `make build`
- `make mocks`
- `make run`
- `make up` / `make down` / `make logs` (если есть compose-стек Docker/PG/Kafka)

### Модель конфигурации

Сервис использует типизированный `AppConfig`:
- приоритет источников: `ENV > YAML > defaults`
- локальные файлы (опционально): `.env.local`, `.env`, `config.local.yaml`
- загрузка только при старте (без runtime reload)

### CI

В сгенерированном репозитории есть GitHub Actions workflow с шагами:
- `make generate`
- `make lint`
- `make test`
- `make build`
- optional проверка compose-конфига при наличии `docker-compose.yml`
