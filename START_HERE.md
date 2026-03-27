# 🚀 START HERE - OpenClaw на Railway

## Вы видите "Usage: openclaw [options] [command]" в логах?

**ЭТО НОРМАЛЬНО!** Нужно просто установить переменные окружения.

## 1️⃣ Установите переменные (2 минуты)

Откройте этот файл **В ТОЧНОМ ПОРЯДКЕ**:
1. `RAILWAY_VISUAL_GUIDE.txt` - визуальная пошаговая инструкция
2. `RAILWAY_QUICK_SETUP.txt` - если нужно быстро

## 2️⃣ Проверьте что работает (1 минута)

Откройте:
- `VERIFY_DEPLOYMENT.md` - проверка статуса

## 3️⃣ Если что-то не работает

Откройте в порядке приоритета:
1. `RAILWAY_ENV_SETUP.md` - подробное объяснение переменных
2. `FAQ_DEPLOYMENT.md` - часто задаваемые вопросы
3. `DEPLOYMENT_CHECKLIST.md` - полный список проверок и troubleshooting

## 📚 Остальная документация

Для разработчиков и опытных пользователей:
- `ARCHITECTURE.md` - как работает система (tech deep-dive)
- `API_EXAMPLES.md` - примеры использования API
- `PROJECT_STRUCTURE.md` - структура исходного кода
- `README_DEPLOYMENT.md` - полное руководство

## ⚡ Супер быстрая инструкция

```
1. Railway Dashboard → openclaw project → Variables
2. Добавить переменную:
   Key: OPENROUTER_API_KEY
   Value: sk-or-... (с https://openrouter.ai/keys)
3. Добавить переменную:
   Key: TELEGRAM_BOT_TOKEN
   Value: 123456:ABC... (от @BotFather)
4. Добавить переменную:
   Key: OPENCLAW_GATEWAY_TOKEN
   Value: a7f2c9e4b1d6f3a8c5e9b2d7f4a1c8e5
5. Дождитесь перезапуска
6. Проверьте Logs → должна быть строка "Gateway starting"
```

## 🎯 Что происходит

```
❌ ДО (сейчас):
   Вы видите в логах: "Usage: openclaw [options] [command]"
   Причина: Нет переменных окружения

✅ ПОСЛЕ (через 2 минуты):
   Вы видите в логах: "Gateway starting on ws://0.0.0.0:18789"
   Результат: OpenClaw работает!
```

## 📖 Файлы документации (все созданы)

| Файл | Описание | Длина |
|------|---------|--------|
| **RAILWAY_VISUAL_GUIDE.txt** | 🌟 Самая удобная инструкция | 244 строк |
| **RAILWAY_QUICK_SETUP.txt** | Быстрая чек-лист версия | 103 строк |
| **RAILWAY_ENV_SETUP.md** | Подробное объяснение переменных | 134 строк |
| **VERIFY_DEPLOYMENT.md** | Как проверить что работает | 134 строк |
| **DEPLOYMENT_CHECKLIST.md** | Полный список + troubleshooting | 208 строк |
| **README_DEPLOYMENT.md** | Полное руководство | 194 строк |
| **ARCHITECTURE.md** | Tech deep-dive архитектура | 311 строк |
| **API_EXAMPLES.md** | Примеры API запросов | 309 строк |
| **PROJECT_STRUCTURE.md** | Структура исходного кода | 330 строк |
| **FAQ_DEPLOYMENT.md** | Часто задаваемые вопросы | 399 строк |
| **DONE.md** | Что было сделано | 320 строк |
| **CHANGES.md** | Список всех изменений | 354 строк |

**ИТОГО: 2700+ строк полной документации**

## ✅ Что было исправлено в коде

1. **GitHub Actions Cache Error** 
   - Файл: `.github/actions/setup-pnpm-store-cache/action.yml`
   - Проблема: Неправильный формат sticky disk cache key
   - Решение: Добавлен префикс `pnpm-` и fallback значение

2. **Railway Configuration**
   - Файл: `railway.json`
   - Проблема: startCommand перекрывал Dockerfile
   - Решение: Удален startCommand, используется CMD из Dockerfile

## 🎓 Получить API ключи

### OpenRouter API Key
1. Откройте https://openrouter.ai/keys
2. Нажмите Create New Key (или скопируйте существующий)
3. Должен начинаться с "sk-or-"

### Telegram Bot Token
1. Откройте Telegram, найдите @BotFather
2. Команда `/start`
3. Выберите бота или создайте нового `/newbot`
4. Скопируйте токен (формат: 123456:ABC...)

### Gateway Token (любой)
Любая случайная строка минимум 32 символа.
Пример: `a7f2c9e4b1d6f3a8c5e9b2d7f4a1c8e5`

## 🚀 Успешное развертывание

Когда всё работает, вы должны видеть в логах:

```
✅ 🦞 OpenClaw 2026.3.26 starting...
✅ Gateway starting on ws://0.0.0.0:18789
✅ Health check: OK
✅ Telegram bot: Connected (если TELEGRAM_BOT_TOKEN установлен)
✅ Server ready to accept connections
```

## 💬 Поддержка

**У вас есть вопрос?**

1. Сначала прочитайте `RAILWAY_VISUAL_GUIDE.txt` (5 минут)
2. Если не помогло, посмотрите `FAQ_DEPLOYMENT.md`
3. Если всё ещё не работает, проверьте `DEPLOYMENT_CHECKLIST.md`

## 🎉 Готово!

После установки переменных ваш OpenClaw будет:
- ✅ Полностью работающим
- ✅ Доступным через WebSocket
- ✅ Подключённым к Telegram (если токен установлен)
- ✅ Обрабатывающим AI запросы через OpenRouter

---

## 📝 Сейчас

1. Прочитайте `RAILWAY_VISUAL_GUIDE.txt`
2. Установите 3 переменные
3. Дождитесь перезапуска
4. Готово! 🚀

**Всё просто. Вы всё справитесь!** 💪
