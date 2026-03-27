# OpenClaw Deployment на Railway

## Автоматизированное развертывание

OpenClaw готов к развертыванию на Railway с использованием Docker.

### Шаги:

1. **Перейдите на Railway.app**
   - Откройте https://railway.app

2. **Создайте новый проект**
   - Нажмите "New Project" → "Deploy from GitHub repo"
   - Выберите репозиторий `prosyanof-a11y/openclaw`

3. **Railway автоматически:**
   - Обнаружит `Dockerfile` в корне репозитория
   - Соберет Docker образ
   - Запустит контейнер с командой: `node openclaw.mjs gateway --allow-unconfigured`

4. **Установите переменные окружения в Railway:**

Перейдите в "Variables" в настройках сервиса и добавьте:

```
OPENROUTER_API_KEY=<ваш ключ от OpenRouter>
TELEGRAM_BOT_TOKEN=<ваш токен от @BotFather>
OPENCLAW_GATEWAY_TOKEN=<любая случайная строка>
```

### Получение API ключей:

- **OPENROUTER_API_KEY**: https://openrouter.ai/keys
- **TELEGRAM_BOT_TOKEN**: Напишите @BotFather в Telegram и следуйте инструкциям

### Port Binding:

Railway автоматически проксирует трафик на порт `18789` (установлен в `railway.json`).

### Health Check:

Endpoint: `GET /healthz`

Railway будет проверять здоровье приложения через этот эндпоинт.

### Логирование:

Railway отображает логи в реальном времени:
```
🦞 OpenClaw 2026.3.26 — running gateway...
```

## Локальное тестирование (опционально)

```bash
# Собрать Docker образ локально
docker build -t openclaw:latest .

# Запустить контейнер
docker run -e OPENROUTER_API_KEY=<ключ> \
           -e TELEGRAM_BOT_TOKEN=<токен> \
           -p 18789:18789 \
           openclaw:latest
```

## Troubleshooting

### "Build failed"
- Проверьте что репозиторий содержит `pnpm-lock.yaml`
- Убедитесь, что `Dockerfile` в корне репозитория

### "Container keeps restarting"
- Проверьте логи на наличие ошибок
- Убедитесь что переменные окружения установлены корректно
- Проверьте `OPENCLAW_GATEWAY_TOKEN` - должно быть установлено

### "Timeout connecting to gateway"
- Gateway может запускаться медленно в первый раз (до 2 минут)
- Проверьте логи: ищите `Server is listening`
