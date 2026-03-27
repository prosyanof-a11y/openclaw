# Инструкции по настройке OpenClaw для Railway

## 1. Получите необходимые ключи API

### OpenRouter API Key
1. Перейдите на https://openrouter.ai/keys
2. Скопируйте ваш API ключ

### Telegram Bot Token
1. Откройте Telegram и найдите @BotFather
2. Отправьте `/start`
3. Отправьте `/newbot`
4. Следуйте инструкциям для создания бота
5. Скопируйте токен в формате `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`

## 2. Подготовьте GitHub репозиторий

Убедитесь что в вашем репозитории:
- ✅ Файл `Dockerfile` в корне
- ✅ Файл `pnpm-lock.yaml` в корне
- ✅ Файл `railway.json` в корне
- ✅ Файл `.github/actions/setup-pnpm-store-cache/action.yml` исправлен (sticky disk cache key)

## 3. Развертывание на Railway

### Вариант A: Через Web UI (рекомендуется)

1. Откройте https://railway.app/dashboard
2. Нажмите "New Project" → "Deploy from GitHub"
3. Выберите репозиторий `prosyanof-a11y/openclaw`
4. Railway автоматически обнаружит `Dockerfile`
5. Дождитесь завершения сборки

### Вариант B: Через Railway CLI

```bash
# Установите Railway CLI
npm install -g @railway/cli

# Откройте Docker Desktop / запустите Docker daemon

# Войдите в Railway
railway login

# Разверните проект
railway up

# Railway автоматически соберет и развернет приложение
```

## 4. Настройка переменных окружения

После развертывания в Railway:

1. Откройте ваш проект в https://railway.app/dashboard
2. Перейдите в Settings → Vars (для переменных)
3. Добавьте переменные:
   ```
   OPENROUTER_API_KEY = <ваш_ключ_от_OpenRouter>
   TELEGRAM_BOT_TOKEN = <ваш_токен_от_BotFather>
   OPENCLAW_GATEWAY_TOKEN = <любая_случайная_строка>
   ```

## 5. Проверка развертывания

После добавления переменных окружения:

1. Railway автоматически перезагрузит приложение
2. Проверьте логи в "Logs" вкладке
3. Ищите сообщение: `🦞 OpenClaw ... — Server is listening`
4. Проверьте что на порту `18789` запущен gateway

## 6. Получение публичного URL

Railway автоматически предоставит вам публичный URL вида:
```
https://<your-railway-project>.up.railway.app
```

Используйте этот URL для:
- Webhooks Telegram бота
- REST API запросов к gateway
- Интеграций с другими сервисами

## 7. Настройка Telegram вебхук

Для получения сообщений в Telegram боте:

```bash
# Установите webhook (замените YOUR_TOKEN и YOUR_URL)
curl -X POST https://api.telegram.org/botYOUR_TOKEN/setWebhook \
  -H "Content-Type: application/json" \
  -d '{"url":"https://<your-railway-project>.up.railway.app/api/telegram/webhook"}'
```

## Справка команд

Когда приложение запущено на Railway:

```bash
# Проверить здоровье gateway
curl https://<your-railway-project>.up.railway.app/healthz

# Отправить сообщение через API
curl -X POST https://<your-railway-project>.up.railway.app/api/message/send \
  -H "Authorization: Bearer YOUR_GATEWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"telegram","target":"@chat","message":"Hello"}'
```

## Troubleshooting

### Build Failed (GitHub Actions)
Если в GitHub Actions ошибка `connection identifier does not contain cache prefix`:
- Уже исправлено в `.github/actions/setup-pnpm-store-cache/action.yml`
- Пересоберите в Railway

### Container Keeps Restarting
1. Проверьте все переменные окружения установлены
2. Проверьте логи на ошибки
3. Убедитесь что `TELEGRAM_BOT_TOKEN` корректный формат

### Timeout на Gateway
- Gateway может запускаться медленно (до 2 минут на первый раз)
- Проверьте логи: ищите `Server is listening on`

### Логи не видны
- Railway показывает последние 100 строк логов
- Для полных логов используйте Railway CLI: `railway logs --follow`

---

**Если что-то не работает:**
1. Проверьте все переменные окружения в Railway
2. Посмотрите логи развертывания
3. Убедитесь что GitHub репозиторий не приватный или Railway имеет к нему доступ
