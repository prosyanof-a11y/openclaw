# Проверка правильности развертывания на Railway

## Checklist: Переменные установлены

### На Railway Dashboard

1. **Откройте Variables:**
   ```
   https://railway.app/dashboard 
   → ваш проект 
   → Variables (вкладка)
   ```

2. **Проверьте наличие трёх переменных:**
   - [ ] `OPENROUTER_API_KEY` - должна быть строка вида `sk-or-...`
   - [ ] `TELEGRAM_BOT_TOKEN` - должна быть строка вида `123456:ABC...`
   - [ ] `OPENCLAW_GATEWAY_TOKEN` - любая строка 32+ символа

3. **Значения должны быть:**
   - [ ] БЕЗ пробелов в начале/конце
   - [ ] БЕЗ кавычек (не "sk-or-...", а sk-or-...)
   - [ ] НЕ пусты

## Проверка логов развертывания

### Шаг 1: Откройте Deployments
```
Railway Dashboard → openclaw → Deployments
```

### Шаг 2: Выберите последний деплой
Нажмите на последний вверху списка.

### Шаг 3: Откройте Logs
Нажмите на вкладку "Logs" или "Build Logs"

### Шаг 4: Ищите эти строки

✅ **УСПЕШНЫЙ ЗАПУСК (должны видеть):**
```
🦞 OpenClaw 2026.3.26 ...
Gateway starting on ws://0.0.0.0:18789
Health check endpoint: /healthz
Server listening on port 18789
```

❌ **ОШИБКА (значит переменные не установлены):**
```
Usage: openclaw [options] [command]
```
В этом случае нужно установить переменные (см. выше).

❌ **ДРУГИЕ ОШИБКИ:**
```
Error: Missing OPENROUTER_API_KEY
Error: Invalid TELEGRAM_BOT_TOKEN
```

## Проверка через API

### Метод 1: Health Check
```bash
# Откройте в браузере или используйте curl:
curl https://<ваш-проект>.up.railway.app/healthz

# Должен вернуть 200 OK и JSON с информацией о здоровье
```

### Метод 2: API Gateway
```bash
# Проверьте работу Gateway API:
curl -X GET https://<ваш-проект>.up.railway.app/api/status \
  -H "Authorization: Bearer a7f2c9e4b1d6f3a8c5e9b2d7f4a1c8e5"
```

### Метод 3: Telegram Bot (если TELEGRAM_BOT_TOKEN установлен)
```bash
# Отправьте сообщение боту:
curl -X POST https://<ваш-проект>.up.railway.app/telegram/webhook \
  -H "Content-Type: application/json" \
  -d '{"message":"test"}'
```

## Если ничего не помогло

### 1. Очистите Docker кэш
```
Railway Dashboard → Settings → Redeploy → "Force New Deployment"
```

### 2. Пересоберите образ
```
Railway Dashboard → Deployments → "Rebuild" (три точки)
```

### 3. Проверьте Dockerfile
```bash
# Dockerfile должен содержать:
CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured", "--bind", "lan"]
```

### 4. Просмотрите полные логи build
```
Deployments → Build Logs (полная история сборки)
```

## Успешное развертывание

Если видите в логах:
```
✅ Build successful
✅ Server listening on port 18789  
✅ Gateway ready to accept connections
```

То всё работает! Приложение полностью развернуто и готово к работе.

## Следующие шаги

После успешного развертывания:

1. **Используйте API:**
   - WebSocket: `wss://<ваш-проект>.up.railway.app`
   - REST: `https://<ваш-проект>.up.railway.app/api/`

2. **Интегрируйте Telegram:**
   - В @BotFather установите Webhook на `https://<ваш-проект>.up.railway.app/telegram/webhook`

3. **Мониторьте логи:**
   - Railway Dashboard → Logs (вкладка)

4. **Масштабируйте при необходимости:**
   - Railway Dashboard → Settings → Resources
