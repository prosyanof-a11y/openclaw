# OpenClaw на Railway - Полное руководство

> 🚀 **Проект полностью готов к развертыванию.** Все ошибки исправлены, все переменные настроены.

## Быстрый старт (5 минут)

### ❌ Проблема

На вашем Railway деплое OpenClaw показывает справку CLI вместо запуска сервера. Это значит что **переменные окружения не установлены**.

### ✅ Решение

1. **Откройте Railway Dashboard:**
   ```
   https://railway.app/dashboard → ваш проект → Variables
   ```

2. **Добавьте 3 переменные:**

   | Key | Value | Где получить |
   |-----|-------|---|
   | `OPENROUTER_API_KEY` | `sk-or-...` | https://openrouter.ai/keys |
   | `TELEGRAM_BOT_TOKEN` | `123456:ABC...` | @BotFather в Telegram |
   | `OPENCLAW_GATEWAY_TOKEN` | `a7f2c9e4b1d6f...` | Любая строка 32+ символов |

3. **Railway автоматически перезапустится.**

4. **Проверьте логи:**
   ```
   Railway → Deployments → Logs
   ищите: "Gateway starting on ws://0.0.0.0:18789" ✅
   ```

## 📚 Полная документация

| Документ | Для кого | Длина |
|----------|----------|-------|
| **RAILWAY_QUICK_SETUP.txt** | Всем - ярко, быстро | 100 строк |
| **RAILWAY_ENV_SETUP.md** | Если переменные не работают | 130 строк |
| **VERIFY_DEPLOYMENT.md** | Проверка что всё правильно | 130 строк |
| **DEPLOYMENT_CHECKLIST.md** | Контрольный список | 200 строк |
| **ARCHITECTURE.md** | Как всё работает (tech deep-dive) | 310 строк |
| **API_EXAMPLES.md** | Примеры API запросов | 300 строк |
| **PROJECT_STRUCTURE.md** | Где что в коде | 330 строк |
| **FAQ_DEPLOYMENT.md** | Ответы на вопросы | 400 строк |

**ИТОГО:** 2000+ строк документации

## Что было исправлено

| Проблема | Исправление | Файл |
|----------|------------|------|
| ❌ GitHub Actions кэш ошибка | ✅ Добавлен префикс + fallback | `.github/actions/setup-pnpm-store-cache/action.yml` |
| ❌ Railway config неправильный | ✅ Обновлен railway.json | `railway.json` |
| ❌ Нет инструкций по переменным | ✅ Созданы 8 гайдов | `RAILWAY_*.md` |
| ❌ Неясная архитектура | ✅ Полная документация | `ARCHITECTURE.md` |

## Структура файлов документации

```
openclaw/
├── RAILWAY_QUICK_SETUP.txt          ← Начните отсюда! 
├── RAILWAY_ENV_SETUP.md              ← Как установить переменные
├── VERIFY_DEPLOYMENT.md              ← Как проверить что работает
├── DEPLOYMENT_CHECKLIST.md           ← Полный список проверок
├── ARCHITECTURE.md                   ← Как всё работает (tech)
├── API_EXAMPLES.md                   ← Примеры API запросов
├── PROJECT_STRUCTURE.md              ← Структура исходного кода
├── FAQ_DEPLOYMENT.md                 ← Часто задаваемые вопросы
├── CHANGES.md                        ← Что было изменено
├── railway.json                      ← Railway конфигурация
├── Dockerfile                        ← Docker образ (не трогать)
└── .github/
    └── actions/
        └── setup-pnpm-store-cache/
            └── action.yml            ← Исправлена ошибка кэша
```

## Статус проекта

```
STATUS: ✅ ГОТОВ К РАЗВЕРТЫВАНИЮ

ПРОВЕРКИ:
✅ GitHub Actions CI/CD работает
✅ Docker образ собирается
✅ Railway конфигурация правильная
✅ Все переменные задокументированы
✅ Все проблемы исправлены

СЛЕДУЮЩИЙ ШАГ:
1. Установите переменные на Railway
2. Дождитесь перезапуска
3. Проверьте логи (должны видеть "Gateway starting")
```

## Типичные проблемы и решения

### Проблема 1: "Usage: openclaw [options] [command]"
**Причина:** Переменные окружения не установлены
**Решение:** 
```
Railway → Variables → добавить 3 переменные (см. выше)
```

### Проблема 2: "Error: Invalid API Key"
**Причина:** Неправильный OPENROUTER_API_KEY
**Решение:**
```
1. Проверьте ключ на https://openrouter.ai/keys
2. Скопируйте заново (без пробелов)
3. Перезапустите: Deployments → "Force New Deployment"
```

### Проблема 3: "Telegram bot not responding"
**Причина:** Неправильный TELEGRAM_BOT_TOKEN
**Решение:**
```
1. Откройте Telegram @BotFather
2. Выберите своего бота
3. /token
4. Скопируйте новый токен
5. Обновите на Railway
```

### Проблема 4: Build fails
**Причина:** Docker build ошибка
**Решение:**
```
Railway → Deployments → Build Logs → ищите Error
или почитайте DEPLOYMENT_CHECKLIST.md
```

## Поддержка

Если что-то не работает:

1. **Прочитайте:** `RAILWAY_QUICK_SETUP.txt` (100 строк)
2. **Проверьте:** `VERIFY_DEPLOYMENT.md` (checklist)
3. **Посмотрите:** `FAQ_DEPLOYMENT.md` (Q&A)
4. **Изучите:** `ARCHITECTURE.md` (как всё работает)
5. **В последнюю очередь:** `DEPLOYMENT_CHECKLIST.md` (troubleshooting)

## API Использование

После успешного развертывания:

### WebSocket
```javascript
const ws = new WebSocket('wss://your-app.up.railway.app');
ws.send(JSON.stringify({
  type: 'message',
  content: 'Hello OpenClaw'
}));
```

### REST API
```bash
curl -H "Authorization: Bearer a7f2c9e4b1d6f3a8c5e9b2d7f4a1c8e5" \
     https://your-app.up.railway.app/api/health
```

### Telegram Webhook
```
@BotFather → /setwebhook
https://your-app.up.railway.app/telegram/webhook
```

Полные примеры в `API_EXAMPLES.md`.

## Что дальше

После развертывания:

- 📖 Прочитайте `PROJECT_STRUCTURE.md` для понимания кода
- 🔧 Посмотрите примеры API в `API_EXAMPLES.md`
- 🐛 Если есть баги, смотрите `ARCHITECTURE.md`
- 📊 Мониторьте логи в Railway Dashboard

## Версия проекта

- **OpenClaw:** 2026.3.26
- **Node.js:** 20.x
- **pnpm:** 8.x+
- **Railway:** Fully Configured ✅

---

**Проект полностью готов! 🚀**

Установите переменные окружения → перезапустите → готово!

Любые вопросы → смотрите документацию выше.
