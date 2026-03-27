# OpenClaw на Railway - Архитектура

## Общая схема развертывания

```
┌─────────────────────────────────────────────────────────────────┐
│                        RAILWAY PLATFORM                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │               OPENCLAW GATEWAY CONTAINER                 │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │                                                            │   │
│  │  PORT 18789 (WebSocket Gateway)                          │   │
│  │  ├─ ws://0.0.0.0:18789 (внутренний)                     │   │
│  │  └─ wss://app.up.railway.app (внешний)                  │   │
│  │                                                            │   │
│  │  Health Check: /healthz                                  │   │
│  │  API: /api/*, /telegram/*, /discord/*, etc              │   │
│  │                                                            │   │
│  └──────────────────────────────────────────────────────────┘   │
│         ▲                          ▲              ▲               │
│         │                          │              │               │
│    ENVIRONMENT VARIABLES    DATABASE (если)  VOLUMES            │
│         │                          │              │               │
│  ┌──────┴──────────────────────────┴──────────────┴──────┐      │
│  │ OPENROUTER_API_KEY                                     │      │
│  │ TELEGRAM_BOT_TOKEN                                     │      │
│  │ OPENCLAW_GATEWAY_TOKEN                                 │      │
│  │ PORT=18789                                             │      │
│  └─────────────────────────────────────────────────────────┘      │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
         ▲                                          ▲
         │                                          │
    GitHub (Git)                              Internet (API Calls)
```

## Поток данных

```
┌──────────────────────────────────────────────────────────────┐
│                    EXTERNAL CLIENTS                            │
├──────────────────────────────────────────────────────────────┤
│  ├─ Telegram Bot (@YourBot)                                 │
│  ├─ Discord Bot                                              │
│  ├─ Custom API Clients                                       │
│  └─ Web Dashboard                                             │
└──────────────┬───────────────────────────────────────────────┘
               │ WebSocket / REST API
               ▼
┌──────────────────────────────────────────────────────────────┐
│           OPENCLAW GATEWAY (Railway Container)               │
├──────────────────────────────────────────────────────────────┤
│  ├─ Channel Manager (Telegram, Discord, etc)                │
│  ├─ Message Router                                           │
│  ├─ Agent Control Protocol (ACP)                            │
│  ├─ Health Monitor (/healthz)                               │
│  └─ WebSocket Handler                                        │
└──────────────┬───────────────────────────────────────────────┘
               │
               ├─────────────────────────────────────────┐
               │                                          │
               ▼                                          ▼
┌────────────────────────────────┐  ┌──────────────────────────┐
│   OpenRouter API               │  │  Telegram/Discord API    │
│   (AI Models)                  │  │  (Messaging Service)     │
├────────────────────────────────┤  ├──────────────────────────┤
│ - GPT-4 Turbo                  │  │ - Message delivery       │
│ - Claude 3 Opus                │  │ - Bot commands           │
│ - Mistral                       │  │ - Channel management     │
│ - Llama 2                       │  │ - User authentication    │
└────────────────────────────────┘  └──────────────────────────┘
```

## Процесс запуска

```
1. GITHUB (Коммит)
   │
   ├─→ GitHub Actions CI
   │   ├─ Проверка синтаксиса
   │   ├─ Сборка TypeScript
   │   └─ Запуск тестов
   │
   └─→ Успешно ✅
   
2. RAILWAY (Deployment)
   │
   ├─→ Получить исходный код
   │
   ├─→ Собрать Docker образ
   │   ├─ FROM node:20 
   │   ├─ COPY openclaw
   │   ├─ RUN pnpm install
   │   └─ BUILD
   │
   ├─→ Запустить контейнер
   │   ├─ Загрузить переменные окружения
   │   ├─ Запустить: node openclaw.mjs gateway
   │   └─ Слушать порт 18789
   │
   └─→ Health Check
       ├─ Проверить /healthz
       ├─ Проверить WebSocket соединение
       └─ Ready ✅

3. RUNNING STATE
   │
   ├─→ Принимать входящие соединения
   ├─→ Обрабатывать сообщения от каналов
   ├─→ Отправлять запросы в OpenRouter API
   ├─→ Маршрутизировать ответы обратно в каналы
   └─→ Логировать события
```

## Компоненты и их взаимодействие

```
┌─────────────────────────────────────────────────────────────┐
│                 OPENCLAW GATEWAY CORE                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           WebSocket Server (Port 18789)             │   │
│  │  Принимает и обрабатывает входящие соединения      │   │
│  └────────────────┬────────────────────────────────────┘   │
│                   │                                          │
│  ┌────────────────▼────────────────────────────────────┐   │
│  │         Message Router & Handler                    │   │
│  │  - Парсит входящее сообщение                       │   │
│  │  - Определяет канал источник                        │   │
│  │  - Маршрутизирует агенту                           │   │
│  └────────────────┬────────────────────────────────────┘   │
│                   │                                          │
│  ┌────────────────▼────────────────────────────────────┐   │
│  │      Agent Control Protocol (ACP)                   │   │
│  │  - Отправляет запрос агенту                        │   │
│  │  - Ожидает ответ                                    │   │
│  │  - Обрабатывает исключения                          │   │
│  └────────────────┬────────────────────────────────────┘   │
│                   │                                          │
│  ┌────────────────▼────────────────────────────────────┐   │
│  │      OpenRouter API Client                          │   │
│  │  - Отправляет промпт AI модели                     │   │
│  │  - Получает сгенерированный ответ                  │   │
│  │  - Обрабатывает потокинг ответов                   │   │
│  └────────────────┬────────────────────────────────────┘   │
│                   │                                          │
│  ┌────────────────▼────────────────────────────────────┐   │
│  │      Channel Writers                                │   │
│  │  - Telegram Writer (отправить в Telegram)          │   │
│  │  - Discord Writer (отправить в Discord)            │   │
│  │  - Custom Writer (отправить в custom канал)        │   │
│  └─────────────────────────────────────────────────────┘   │
│                   │                                          │
│  ┌────────────────▼────────────────────────────────────┐   │
│  │      Response Delivery                              │   │
│  │  Ответ отправлен обратно пользователю ✅           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Распределение портов и сервисов

```
КОНТЕЙНЕР (OpenClaw Gateway)
├── Port 18789 (главный WebSocket Gateway)
│   ├─ WebSocket: ws://0.0.0.0:18789
│   ├─ Health Check: GET /healthz
│   ├─ API: GET/POST /api/*
│   └─ Webhooks: POST /telegram/*, /discord/*, etc
│
└── Иные сервисы (внутри контейнера)
    ├─ Agent Control Protocol (IPC)
    ├─ File System (state, logs, cache)
    └─ Memory Cache (in-memory state)

СНАРУЖИ (Railway Proxy)
├── HTTP/HTTPS Load Balancer
│   └─ Маршрутизирует трафик на Port 18789
│
└── WebSocket Proxy
    └─ Проксирует ws:// -> wss://
```

## Поток данных при отправке сообщения

```
User в Telegram
    │
    ├─→ @YourBot /help
    │
    └─→ Telegram API
        │
        ├─→ Webhook POST https://app.up.railway.app/telegram/webhook
        │   │
        │   ├─→ Railway Ingress (HTTPS)
        │   │
        │   ├─→ Container Port 18789
        │   │
        │   ├─→ OpenClaw Gateway
        │   │   │
        │   │   ├─→ Parse Telegram Message
        │   │   ├─→ Extract text & metadata
        │   │   └─→ Create request object
        │   │
        │   ├─→ Agent Control Protocol
        │   │   │
        │   │   ├─→ Send to Agent
        │   │   └─→ Wait for response
        │   │
        │   ├─→ OpenRouter API Call
        │   │   │
        │   │   OPENROUTER_API_KEY=sk-or-...
        │   │   Model: gpt-4-turbo
        │   │   Prompt: "User asked: help"
        │   │   │
        │   │   └─→ Receive generated response
        │   │
        │   ├─→ Format Response
        │   │   │
        │   │   └─→ Telegram Message Format
        │   │
        │   └─→ Telegram Writer
        │       │
        │       ├─→ Format message
        │       ├─→ Call Telegram API
        │       └─→ Send to user
        │
        └─→ User видит ответ в Telegram ✅
```

## Переменные окружения и их использование

```
OPENROUTER_API_KEY
├─ Used by: OpenRouter API Client
├─ Format: sk-or-v1-...
├─ Source: https://openrouter.ai/keys
└─ Impact: ❌ БЕЗ неё не работают AI запросы

TELEGRAM_BOT_TOKEN  
├─ Used by: Telegram Channel Handler
├─ Format: 123456:ABCDefGHIJKL...
├─ Source: @BotFather /newbot
└─ Impact: ❌ БЕЗ неё не работает Telegram интеграция

OPENCLAW_GATEWAY_TOKEN
├─ Used by: Gateway Authentication
├─ Format: Any string 32+ chars
├─ Source: Generate with openssl rand -hex 32
└─ Impact: ⚠️  БЕЗ неё некоторые API требуют безопасности

PORT (опционально)
├─ Used by: Server binding
├─ Default: 18789
├─ Override: PORT=19000
└─ Impact: ⚠️  Для смены port при необходимости
```

## Масштабирование и мониторинг

```
МОНИТОРИНГ:
├─ Health Check: /healthz (каждые 30 сек)
├─ Logs: Railway Dashboard → Logs
├─ Metrics: CPU, Memory, Network
└─ Alerts: Настроить в Railway Settings

МАСШТАБИРОВАНИЕ:
├─ Vertical: Railway → Settings → Resources
│   ├─ CPU: 0.5 → 4 cores
│   └─ RAM: 512MB → 32GB
│
└─ Horizontal: Railway не поддерживает нативно
    └─ Вариант: Используйте несколько деплоев

ОБНОВЛЕНИЕ:
├─ Code: Push in GitHub → Railway auto-deploys
├─ Config: Railway Variables → auto-redeploy
└─ Version: Railway → Redeploy
```

## Безопасность и изоляция

```
КОНТЕЙНЕР (изолирован)
├─ Не имеет доступа к хост системе
├─ Все файлы в контейнере временные
├─ State хранится в /data (опционально)
└─ Логи отправляются в Railway Logs

СЕТЬ (защищена)
├─ Входящий трафик только через Railway Load Balancer
├─ Исходящий трафик только на разрешённые адреса
├─ TLS/SSL для всех внешних соединений
└─ API ключи не видны в URL (headers)

ПРИВАТНОСТЬ (строгая)
├─ Переменные окружения не видны в исходном коде
├─ Логи доступны только владельцу проекта
├─ Трафик зашифрован (wss:// вместо ws://)
└─ Ротация ключей рекомендуется каждые 90 дней
```

---

**Это полная архитектура OpenClaw на Railway.** Все компоненты работают вместе для обеспечения надежной, масштабируемой платформы для многоканальной AI обработки.
