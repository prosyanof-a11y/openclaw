# ✅ OpenClaw Railway Deployment - Checklist

Используйте этот контрольный список для быстрого развертывания на Railway.

## Подготовка (5 минут)

- [ ] Зарегистрируйтесь на https://railway.app (если еще нет)
- [ ] Получите OPENROUTER_API_KEY с https://openrouter.ai/keys
- [ ] Получите TELEGRAM_BOT_TOKEN от @BotFather в Telegram
- [ ] Генерируйте случайную строку для OPENCLAW_GATEWAY_TOKEN (например: `openssl rand -hex 16`)

## GitHub Проверка (2 минуты)

- [ ] Убедитесь что репозиторий public или Railway имеет доступ
- [ ] Проверьте что файлы в корне репозитория:
  - [ ] `Dockerfile` существует
  - [ ] `pnpm-lock.yaml` существует
  - [ ] `railway.json` существует
  - [ ] `.github/actions/setup-pnpm-store-cache/action.yml` исправлен

## Развертывание на Railway (3 минуты)

### Via Web UI (рекомендуется)

1. [ ] Откройте https://railway.app/dashboard
2. [ ] Нажмите "New Project" → "Deploy from GitHub"
3. [ ] Выберите репозиторий `prosyanof-a11y/openclaw`
4. [ ] Нажмите "Deploy"

### Via Railway CLI (альтернатива)

1. [ ] Установите Railway CLI: `npm install -g @railway/cli`
2. [ ] Откройте Docker Desktop
3. [ ] Выполните: `railway login`
4. [ ] Выполните: `railway up`

## Конфигурация переменных (1 минута)

После того как deployment начался:

1. [ ] Перейдите в Dashboard проекта
2. [ ] Откройте Settings → Vars
3. [ ] Добавьте переменные:
   ```
   OPENROUTER_API_KEY = <скопируйте с openrouter.ai>
   TELEGRAM_BOT_TOKEN = <скопируйте от @BotFather>
   OPENCLAW_GATEWAY_TOKEN = <генерированная строка>
   ```
4. [ ] Нажмите "Save"
5. [ ] Railway автоматически перезагрузит приложение

## Проверка развертывания (2 минуты)

1. [ ] Откройте вкладку "Logs" в Railway
2. [ ] Ищите сообщение: `🦞 OpenClaw ... — Server is listening`
3. [ ] Если есть ошибки, смотрите нашу таблицу troubleshooting ниже
4. [ ] Проверьте что статус приложения "Running" (зеленый)

## Тестирование (2 минуты)

В терминале проверьте здоровье gateway:

```bash
# Замените <your-railway-project> на имя вашего проекта
curl https://<your-railway-project>.up.railway.app/healthz

# Должен ответить:
# {"status":"ok","timestamp":"..."}
```

## Telegram Webhook Setup (1 минута) - опционально

Для получения сообщений в боте:

```bash
curl -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://<your-railway-project>.up.railway.app/api/telegram/webhook"
  }'
```

---

## Troubleshooting

### ❌ Build Failed in GitHub Actions

**Статус:** ✅ Уже исправлено

**Причина:** Ошибка в sticky disk cache key

**Решение:** Файл `.github/actions/setup-pnpm-store-cache/action.yml` уже исправлен

**Что делать:**
1. Пересоберите в Railway (нажмите "Redeploy" в Dashboard)
2. Подождите завершения сборки

### ❌ Container Keeps Restarting

**Признак:** Логи постоянно повторяются, статус не становится "Running"

**Причины:**
1. Переменные окружения не установлены или пусты
2. TELEGRAM_BOT_TOKEN в неправильном формате
3. OPENROUTER_API_KEY невалидный

**Как исправить:**
1. [ ] Проверьте все переменные в Settings → Vars:
   - OPENROUTER_API_KEY должен начинаться с `sk-`
   - TELEGRAM_BOT_TOKEN должен быть числом и буквами (например: `123456:ABC-DEF...`)
   - OPENCLAW_GATEWAY_TOKEN может быть любой строкой
2. [ ] Нажмите "Redeploy" после изменения переменных

### ❌ Timeout / Connection Refused

**Признак:** `curl: (7) Failed to connect`

**Причины:**
1. Gateway еще не запустился (медленный старт)
2. Приложение не готово к запросам
3. Неправильный URL

**Как исправить:**
1. [ ] Подождите 30 секунд и попробуйте снова
2. [ ] Проверьте что URL правильный: `https://<название-проекта>.up.railway.app`
3. [ ] Посмотрите логи: `Logs` → ищите "Server is listening on port"
4. [ ] Если логи пусты, нажмите "Redeploy"

### ❌ 502 Bad Gateway

**Признак:** Сообщение об ошибке при запросе к API

**Причины:**
1. Gateway перезагружается
2. Нет подключения к OpenRouter API
3. OPENROUTER_API_KEY невалидный

**Как исправить:**
1. [ ] Подождите 1-2 минуты
2. [ ] Проверьте что OPENROUTER_API_KEY установлена в Settings → Vars
3. [ ] Нажмите "Redeploy"

### ❌ 503 Service Unavailable

**Признак:** Service temporarily unavailable

**Причины:**
1. Gateway перегружен
2. Проблемы с OpenRouter API
3. Слишком много одновременных соединений

**Как исправить:**
1. [ ] Подождите несколько минут
2. [ ] Проверьте статус OpenRouter: https://status.openrouter.ai
3. [ ] Если проблема сохраняется, нажмите "Redeploy"

### ❌ Логи не видны в Railway

**Признак:** Вкладка "Logs" пуста или показывает старые логи

**Как исправить:**
```bash
# Используйте Railway CLI для просмотра полных логов
railway logs --follow

# Или нажмите "Redeploy" в UI чтобы заново собрать образ
```

### ❌ Webhook не получает сообщения из Telegram

**Признак:** Бот отправляет сообщения но они не проходят через OpenClaw

**Как исправить:**
1. [ ] Проверьте что webhook установлена:
```bash
curl https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getWebhookInfo
```
2. [ ] Убедитесь что URL правильный: `https://<ваш-проект>.up.railway.app/api/telegram/webhook`
3. [ ] Переустановите webhook:
```bash
curl -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook \
  -d url="https://<ваш-проект>.up.railway.app/api/telegram/webhook"
```

---

## Завершение

- [ ] Все переменные окружения установлены
- [ ] Приложение запущено (статус "Running")
- [ ] Health check возвращает `{"status":"ok"}`
- [ ] Логи не содержат ошибок
- [ ] (опционально) Webhook установлена и работает

**Поздравляем! 🎉 OpenClaw успешно развернут на Railway!**

---

## Дополнительные ссылки

- 📖 [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) - Подробная инструкция
- 📖 [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) - Информация о Railway
- 📖 [API_EXAMPLES.md](API_EXAMPLES.md) - Примеры API запросов
- 📖 [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) - Что было сделано
- 🔗 [Railway Documentation](https://railway.app/docs)
- 🔗 [OpenClaw Documentation](https://docs.openclaw.ai)
