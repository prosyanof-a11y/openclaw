# Установка переменных окружения на Railway

## Проблема
OpenClaw требует несколько обязательных переменных окружения для работы:
- `OPENROUTER_API_KEY` - для работы с AI моделями
- `TELEGRAM_BOT_TOKEN` - для работы Telegram бота
- `OPENCLAW_GATEWAY_TOKEN` - токен для безопасности API

Без них приложение показывает справку CLI и не запускается.

## Решение: Пошаговая установка на Railway

### Шаг 1: Откройте Dashboard Railway
1. Зайдите на https://railway.app/dashboard
2. Найдите ваш проект "openclaw"
3. Нажмите на проект, чтобы открыть его

### Шаг 2: Перейдите на вкладку Variables (Переменные)
```
Dashboard → openclaw (проект) → Variables
```

### Шаг 3: Добавьте переменные одну за одной

#### Переменная 1: OPENROUTER_API_KEY
```
Key:   OPENROUTER_API_KEY
Value: <ваш API ключ с https://openrouter.ai/keys>
```
**Как получить:**
- Зайдите на https://openrouter.ai/keys
- Скопируйте API ключ (начинается с "sk-")

#### Переменная 2: TELEGRAM_BOT_TOKEN
```
Key:   TELEGRAM_BOT_TOKEN
Value: <ваш токен от @BotFather>
```
**Как получить:**
- Откройте Telegram
- Напишите @BotFather
- Команда `/start`
- Выберите своего бота или создайте нового
- Скопируйте токен

#### Переменная 3: OPENCLAW_GATEWAY_TOKEN
```
Key:   OPENCLAW_GATEWAY_TOKEN
Value: a7f2c9e4b1d6f3a8c5e9b2d7f4a1c8e5
```
(Или любая другая случайная строка минимум 32 символа)

### Шаг 4: Сохраните и перезапустите
1. Нажмите кнопку "Save" (если есть)
2. Railway автоматически перезапустит приложение с новыми переменными
3. Проверьте логи деплоя

## Проверка что все работает

### Через Railway Dashboard
```
Railway → openclaw → Deployments → последний деплой → Logs
```
Должны увидеть:
```
🦞 OpenClaw ... 
✅ Gateway starting on ws://0.0.0.0:18789
```

### Через API
```bash
curl -H "Authorization: Bearer a7f2c9e4b1d6f3a8c5e9b2d7f4a1c8e5" \
     https://<ваш-проект>.up.railway.app/healthz
```
Должен вернуть 200 OK.

## Если переменные не применяются

1. **Очистите кэш Railway:**
   - Dashboard → Settings → Redeploy
   - Нажмите "Force New Deployment"

2. **Проверьте синтаксис:**
   - Нет пробелов в начале/конце значения
   - Нет кавычек вокруг значения

3. **Проверьте логи:**
   - Deployments → Logs
   - Ищите "Error" или "FATAL"

## Переменные окружения в Dockerfile

Dockerfile уже настроен на использование переменных:
```dockerfile
CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured", "--bind", "lan"]
```

OpenClaw автоматически читает переменные из окружения.

## Альтернативный способ через .env

Если по какой-то причине переменные не устанавливаются:

1. Создайте файл `.env.railway`:
```env
OPENROUTER_API_KEY=ваш_ключ
TELEGRAM_BOT_TOKEN=ваш_токен
OPENCLAW_GATEWAY_TOKEN=ваш_токен
```

2. Обновите Dockerfile:
```dockerfile
COPY .env.railway .env
```

Но **рекомендуется использовать Railway Variables**, это безопаснее.

## Безопасность

⚠️ **ВАЖНО:**
- Никогда не коммитьте `.env` в Git
- Используйте только Railway Variables для хранения ключей
- Ротируйте API ключи регулярно
- Используйте разные ключи для prod/dev

## Успех!

Когда переменные установлены и приложение запущено, вы должны видеть:
- ✅ Gateway listening
- ✅ Health check passing
- ✅ Telegram bot active (если TELEGRAM_BOT_TOKEN установлен)

Поздравляем! OpenClaw готов к работе 🎉
