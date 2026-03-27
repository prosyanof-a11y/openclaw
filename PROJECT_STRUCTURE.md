# 📁 OpenClaw Project Structure

OpenClaw - многоканальный AI шлюз с поддержкой множества интеграций.

## Основная структура

```
openclaw/
├── src/                          # Исходный код CLI и Gateway
│   ├── entry.ts                  # Точка входа приложения
│   ├── cli/                      # Команды CLI
│   ├── gateway/                  # WebSocket Gateway сервер
│   ├── agents/                   # AI agent система
│   ├── config/                   # Конфигурация и валидация
│   ├── channels/                 # Базовые каналы (Telegram, Discord и т.д.)
│   ├── commands/                 # CLI команды
│   ├── hooks/                    # Системные hooks
│   └── infra/                    # Infrastructure (logging, env, ports и т.д.)
│
├── extensions/                   # Расширения и плагины
│   ├── telegram/                 # Telegram интеграция
│   ├── discord/                  # Discord интеграция
│   ├── openrouter/               # OpenRouter AI интеграция
│   ├── whatsapp/                 # WhatsApp интеграция
│   ├── matrix/                   # Matrix/Element интеграция
│   └── ... (другие каналы)
│
├── ui/                           # Web интерфейс Dashboard
│   ├── src/                      # React компоненты
│   ├── public/                   # Статические файлы
│   └── package.json
│
├── apps/                         # Мобильные и десктопные приложения
│   ├── macos/                    # macOS приложение (Swift)
│   ├── ios/                      # iOS приложение (SwiftUI)
│   └── android/                  # Android приложение (Kotlin)
│
├── skills/                       # AI Skills (специализированные инструменты)
│   ├── 1password/                # 1Password интеграция
│   ├── bluebubbles/              # Blue Bubbles интеграция
│   ├── node-connect/             # Node.js интеграция
│   └── ... (другие skills)
│
├── docs/                         # Документация
│   ├── install/                  # Инструкции по установке
│   ├── gateway/                  # Документация Gateway
│   ├── channels/                 # Документация каналов
│   ├── providers/                # Документация провайдеров AI
│   ├── platforms/                # Информация по платформам
│   └── plugins/                  # Документация плагинов
│
├── .github/                      # GitHub конфигурация
│   ├── workflows/                # GitHub Actions workflows
│   └── actions/                  # Пользовательские actions
│
├── scripts/                      # Build и utility скрипты
│   ├── tsdown-build.mjs          # TypeScript компилятор
│   ├── runtime-postbuild.mjs     # Post-build обработка
│   ├── build-stamp.mjs           # Build метаинформация
│   └── ... (другие скрипты)
│
├── test/                         # Интеграционные тесты
├── Dockerfile                    # Docker образ для контейнеризации
├── package.json                  # Root package.json (monorepo)
├── pnpm-lock.yaml               # Dependencies lock файл
├── pnpm-workspace.yaml          # pnpm workspace конфигурация
├── tsconfig.json                # TypeScript конфигурация
├── railway.json                 # Railway deployment конфигурация
├── DEPLOYMENT_CHECKLIST.md      # Чеклист развертывания
├── SETUP_INSTRUCTIONS.md        # Инструкции по настройке
├── RAILWAY_DEPLOYMENT.md        # Railway-специфичная информация
├── API_EXAMPLES.md              # Примеры использования API
└── README.md                    # Главная документация
```

## Ключевые файлы для Railway развертывания

### Конфигурация

| Файл | Назначение | Статус |
|------|-----------|--------|
| `Dockerfile` | Docker образ для контейнеризации | ✅ Готов |
| `railway.json` | Конфигурация Railway | ✅ Обновлен |
| `.github/actions/setup-pnpm-store-cache/action.yml` | GitHub Actions cache config | ✅ Исправлен |
| `pnpm-lock.yaml` | Зафиксированные зависимости | ✅ Готов |
| `pnpm-workspace.yaml` | Структура monorepo | ✅ Готов |

### Исходный код входной точки

| Файл | Назначение |
|------|-----------|
| `src/entry.ts` | Главная точка входа приложения |
| `src/cli/gateway-cli/run.ts` | Gateway запуск логика |
| `src/gateway/server-startup.ts` | Gateway инициализация |

### Расширения

| Директория | Назначение |
|-----------|-----------|
| `extensions/telegram/` | Telegram бот интеграция |
| `extensions/openrouter/` | OpenRouter AI API интеграция |
| `extensions/discord/` | Discord интеграция |
| `extensions/whatsapp/` | WhatsApp интеграция |

## Как работает приложение

```
1. openclaw.mjs (точка входа)
   ↓
2. src/entry.ts (инициализация CLI)
   ↓
3. Парсинг аргументов (например: "gateway --allow-unconfigured")
   ↓
4. src/cli/gateway-cli/run.ts (запуск Gateway)
   ↓
5. src/gateway/server-startup.ts (инициализация WebSocket сервера)
   ↓
6. Загрузка расширений (telegram, discord, openrouter и т.д.)
   ↓
7. WebSocket Gateway слушает на порту 18789
   ↓
8. Gateway готов к приему сообщений и запросов
```

## Структура расширений (Extensions)

Каждое расширение имеет стандартную структуру:

```
extensions/telegram/
├── src/
│   ├── index.ts                  # Главный файл расширения
│   ├── config-schema.ts          # Конфигурация и валидация
│   ├── channel.ts                # Реализация канала
│   ├── channel.startup.ts        # Логика инициализации
│   ├── channel.runtime.ts        # Логика выполнения
│   ├── channel.inbound.ts        # Обработка входящих сообщений
│   ├── channel.outbound.ts       # Отправка исходящих сообщений
│   └── ... (другие файлы)
├── package.json                  # Зависимости расширения
└── README.md                     # Документация расширения
```

## Configuration System

OpenClaw использует гибкую систему конфигурации:

```
1. Окружение (процесс чтения переменных окружения)
   ↓
2. Конфиг файлы (~/.openclaw/config.json)
   ↓
3. Interactive Setup (команда `openclaw configure`)
   ↓
4. Валидация через schema (src/config/schema.base.generated.ts)
   ↓
5. Runtime configuration (src/config/io.ts)
```

## Monorepo Structure

OpenClaw использует **pnpm workspaces** для управления монорепо:

```json
// pnpm-workspace.yaml
packages:
  - "ui"
  - "apps/*"
  - "extensions/*"
  - "skills/*"
```

Это позволяет:
- Управлять зависимостями между пакетами
- Общие версии dependencies
- Быстрые сборки с кэшем

## Build Process

```
pnpm install           # Установка зависимостей
    ↓
pnpm build            # Сборка основного кода
    ↓
pnpm ui:build         # Сборка Web UI
    ↓
node scripts/...      # Post-build обработка
    ↓
Готовый dist/ папка   # Скомпилированный код
```

## Testing

OpenClaw имеет структурированную систему тестирования:

```
test/                          # E2E и интеграционные тесты
src/**/*.test.ts              # Unit тесты рядом с кодом
src/**/*.integration.test.ts  # Интеграционные тесты

Выполнение:
pnpm test              # Все тесты
pnpm test:unit         # Только unit тесты
pnpm test:integration  # Только интеграционные тесты
```

## Documentation Structure

```
docs/
├── install/           # Инструкции по установке
│   ├── docker.md      # Docker развертывание
│   ├── railway.md     # Railway развертывание
│   ├── podman.md      # Podman развертывание
│   └── ...
├── gateway/           # Gateway документация
│   ├── index.md       # Обзор
│   ├── configuration.md
│   ├── authentication.md
│   └── troubleshooting.md
├── channels/          # Документация каналов
│   ├── telegram.md
│   ├── discord.md
│   └── ...
├── providers/         # Документация AI провайдеров
│   ├── openrouter.md
│   ├── anthropic.md
│   └── ...
└── platforms/         # Платформ-специфичные инструкции
    ├── raspberry-pi.md
    ├── macos.md
    ├── windows.md
    └── ...
```

## Environment Variables

### Основные переменные

| Переменная | Описание | Обязательная |
|-----------|---------|------------|
| `OPENROUTER_API_KEY` | API ключ для OpenRouter | ✅ Да |
| `TELEGRAM_BOT_TOKEN` | Token Telegram бота | ✅ Да |
| `OPENCLAW_GATEWAY_TOKEN` | Токен безопасности gateway | ❌ Нет |
| `PORT` | Порт на котором слушает gateway | ❌ (default: 18789) |
| `OPENCLAW_STATE_DIR` | Директория для хранения состояния | ❌ (default: ~/.openclaw) |
| `OPENCLAW_CONFIG_PATH` | Путь к конфигу | ❌ (default: ~/.openclaw/config.json) |
| `LOG_LEVEL` | Уровень логирования | ❌ (default: info) |

### Расширенные переменные

```bash
# Development
OPENCLAW_DEV=1                  # Разработческий режим
NODE_ENV=development           # Node.js environment

# Logging
LOG_LEVEL=debug                # Подробное логирование
OPENCLAW_LOG_FORMAT=json       # JSON логи

# Performance
NODE_OPTIONS=--max-old-space-size=2048  # Лимит памяти

# Docker
OPENCLAW_CONTAINER=<name>      # Имя Docker контейнера
```

## Dependencies

### Основные зависимости

- **Node.js**: v22+ (см. openclaw.mjs для проверки версии)
- **pnpm**: v9+ (менеджер пакетов)
- **TypeScript**: Используется для исходного кода
- **Bun**: Для build скриптов

### Ключевые библиотеки

- **ws**: WebSocket реализация
- **axios/node-fetch**: HTTP запросы
- **zod**: Schema валидация
- **commander.js**: CLI парсинг

## Performance Considerations

```
1. Lazy Loading Extensions
   - Расширения загружаются только когда нужны
   - Ускоряет старт приложения

2. Connection Pooling
   - Переиспользование соединений
   - Меньше overhead на новые соединения

3. Message Queuing
   - Асинхронная обработка сообщений
   - Предотвращает блокировку

4. Caching
   - Config caching
   - Model response caching
```

## Security

```
1. Token-based Authentication
   - OPENCLAW_GATEWAY_TOKEN для API доступа
   - Channel-specific токены (Telegram, Discord и т.д.)

2. TLS/HTTPS
   - WebSocket использует WSS (Secure WebSocket)
   - HTTP endpoints используют HTTPS в production

3. Input Validation
   - Все входные данные валидируются через Zod schemas
   - SQL injection защита через параметризованные запросы

4. Rate Limiting
   - Per-IP ограничения
   - Per-token ограничения
```

---

**Дополнительно:**
- 📖 [README.md](README.md) - Главная документация
- 📖 [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) - Что было сделано
- 📖 [API_EXAMPLES.md](API_EXAMPLES.md) - Примеры использования
