# 🚀 OpenClaw Railway Deployment - Index

Быстрый доступ к документации по развертыванию на Railway.

## Быстрый старт (⏱️ 10 минут)

### Для нетерпеливых

```bash
# 1. Установите переменные на Railway
OPENROUTER_API_KEY=<ваш_ключ>
TELEGRAM_BOT_TOKEN=<ваш_токен>

# 2. Нажмите "Redeploy" в Railway Dashboard

# 3. Проверьте здоровье
curl https://<ваш-проект>.up.railway.app/healthz

# 4. Готово! 🎉
```

**Нужна помощь?** Читайте [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

---

## Документация по развертыванию

### 📋 Для каждого этапа

| Этап | Документация | Время |
|------|-----------|------|
| **Подготовка** | [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) | 10 мин |
| **Развертывание** | [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) | 5 мин |
| **Конфигурация** | [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) | 5 мин |
| **Проверка** | [API_EXAMPLES.md](API_EXAMPLES.md) | 5 мин |
| **Troubleshooting** | [FAQ_DEPLOYMENT.md](FAQ_DEPLOYMENT.md) | По необходимости |

### 📚 Справочная информация

| Тема | Документация | Для кого |
|------|-----------|---------|
| **Что было сделано** | [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) | Менеджеры, архитекторы |
| **Структура проекта** | [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) | Разработчики, DevOps |
| **API примеры** | [API_EXAMPLES.md](API_EXAMPLES.md) | Разработчики |
| **Частые вопросы** | [FAQ_DEPLOYMENT.md](FAQ_DEPLOYMENT.md) | Все |

---

## Пошаговое развертывание

### 1️⃣ Получите API ключи (5 минут)

- [ ] OPENROUTER_API_KEY от https://openrouter.ai/keys
- [ ] TELEGRAM_BOT_TOKEN от @BotFather в Telegram

👉 [Подробно в SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md#1-получите-необходимые-ключи-api)

### 2️⃣ Проверьте GitHub (2 минуты)

- [ ] Dockerfile в корне
- [ ] pnpm-lock.yaml в корне
- [ ] railway.json в корне
- [ ] .github/actions/.../action.yml исправлен

👉 [Подробно в SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md#2-подготовьте-github-репозиторий)

### 3️⃣ Разверните на Railway (3 минуты)

**Вариант A (Web UI - рекомендуется):**
1. Откройте https://railway.app/dashboard
2. "New Project" → "Deploy from GitHub"
3. Выберите репозиторий
4. Ждите завершения

**Вариант B (CLI):**
```bash
railway up
```

👉 [Подробно в SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md#3-развертывание-на-railway)

### 4️⃣ Установите переменные (1 минута)

На Railway в Settings → Vars добавьте:
```
OPENROUTER_API_KEY = <скопируйте>
TELEGRAM_BOT_TOKEN = <скопируйте>
OPENCLAW_GATEWAY_TOKEN = <любая строка>
```

👉 [Подробно в DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md#конфигурация-переменных-1-минута)

### 5️⃣ Проверьте развертывание (2 минуты)

```bash
curl https://<ваш-проект>.up.railway.app/healthz
# {"status":"ok","timestamp":"..."}
```

👉 [Подробно в DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md#проверка-развертывания-2-минуты)

---

## Справочные таблицы

### Переменные окружения

```bash
# Обязательные
OPENROUTER_API_KEY=sk-...          # OpenRouter API ключ
TELEGRAM_BOT_TOKEN=123456:ABC-...  # Telegram токен

# Опциональные
OPENCLAW_GATEWAY_TOKEN=random-str  # Токен безопасности
PORT=18789                          # Порт (default: 18789)
LOG_LEVEL=info                      # Уровень логирования
```

Подробнее: [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md#environment-variables)

### Основные команды

```bash
# Health check
curl https://<проект>.up.railway.app/healthz

# API запрос
curl -X POST https://<проект>.up.railway.app/api/agent \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Hello"}'

# Telegram webhook
curl -X POST https://api.telegram.org/bot${TOKEN}/setWebhook \
  -d url="https://<проект>.up.railway.app/api/telegram/webhook"

# Просмотр логов (CLI)
railway logs --follow
```

Подробнее: [API_EXAMPLES.md](API_EXAMPLES.md)

---

## Troubleshooting Быстрая помощь

### ❌ Build Failed

**Решение:** Проверьте что все файлы в корне репозитория
- [ ] Dockerfile ✅
- [ ] pnpm-lock.yaml ✅
- [ ] railway.json ✅

👉 [Подробный troubleshooting](DEPLOYMENT_CHECKLIST.md#troubleshooting)

### ❌ Container Keeps Restarting

1. [ ] Проверьте переменные в Settings → Vars
2. [ ] Нажмите "Redeploy"
3. [ ] Посмотрите логи на ошибки

👉 [Подробный troubleshooting](FAQ_DEPLOYMENT.md#container-keeps-restarting)

### ❌ Timeout / Connection Refused

1. [ ] Подождите 30 секунд
2. [ ] Проверьте что статус "Running"
3. [ ] Посмотрите логи

👉 [Подробный troubleshooting](FAQ_DEPLOYMENT.md#timeout--connection-refused)

### ❌ 502 / 503 Ошибки

1. [ ] Подождите 1-2 минуты
2. [ ] Проверьте OPENROUTER_API_KEY
3. [ ] Нажмите "Redeploy"

👉 [Все ошибки в FAQ](FAQ_DEPLOYMENT.md#ошибка-502-bad-gateway)

---

## Для разных ролей

### 👨‍💼 Менеджер / Руководитель

**Что нужно знать:**
- Приложение развернуто на Railway (облачный сервис)
- Стоимость: ~$12/месяц (Railway) + OpenRouter (pay-as-you-go)
- Время развертывания: ~10 минут
- Вверх-деплой возможен за 1-2 минуты

**Документы для прочтения:**
1. [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) - Что было сделано
2. [FAQ_DEPLOYMENT.md](FAQ_DEPLOYMENT.md) - Ответы на вопросы

### 👨‍💻 Разработчик / DevOps

**Что нужно знать:**
- Используется Docker для контейнеризации
- pnpm workspaces для управления монорепо
- GitHub Actions для CI/CD (исправлена ошибка с cache)
- WebSocket Gateway на порту 18789

**Документы для прочтения:**
1. [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Структура проекта
2. [API_EXAMPLES.md](API_EXAMPLES.md) - API примеры
3. [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) - Что изменилось

### 👤 DevOps / Инженер инфраструктуры

**Что нужно знать:**
- Dockerfile готов к использованию
- railway.json содержит конфигурацию для Railway
- Переменные окружения управляются через Railway UI
- Health check доступен на `/healthz`

**Документы для прочтения:**
1. [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Полная конфигурация
2. [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Архитектура
3. Оригинальные файлы:
   - `Dockerfile` - Docker образ
   - `railway.json` - Railway конфигурация
   - `.github/actions/...` - GitHub Actions

---

## Полезные ссылки

### OpenClaw
- 📖 [Официальная документация](https://docs.openclaw.ai)
- 🔗 [GitHub репозиторий](https://github.com/openclaw/openclaw)
- 📚 [API документация](https://docs.openclaw.ai/api)

### Railway
- 📖 [Railway документация](https://railway.app/docs)
- 🔗 [Railway Dashboard](https://railway.app/dashboard)
- 💬 [Railway Community](https://railway.app/community)

### AI Провайдеры
- 📖 [OpenRouter документация](https://openrouter.ai/docs)
- 💰 [OpenRouter ценообразование](https://openrouter.ai/pricing)
- 🔗 [Поддерживаемые модели](https://openrouter.ai/models)

### Telegram
- 📖 [Telegram Bot API](https://core.telegram.org/bots/api)
- 🤖 [@BotFather](https://t.me/botfather)
- 📚 [Telegram документация](https://core.telegram.org/bots)

---

## Резюме

✅ **OpenClaw готов к развертыванию на Railway**

- Исправлена ошибка GitHub Actions cache key
- Конфигурирована работа с Docker
- Подготовлена complete документация
- Готовы переменные окружения для Railway

**Дальше:**

1. Получите API ключи (10 минут)
2. Разверните на Railway (5 минут)
3. Установите переменные окружения (1 минута)
4. Проверьте что работает (2 минуты)

**Итого: ~20 минут до полной настройки** ⏱️

---

**Начните с:** [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) или [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

**Вопросы?** Смотрите [FAQ_DEPLOYMENT.md](FAQ_DEPLOYMENT.md)
