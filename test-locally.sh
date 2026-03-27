#!/bin/bash

# OpenClaw Local Docker Test
# Это скрипт для локального тестирования Docker образа перед развертыванием на Railway

set -e

echo "🐳 OpenClaw Local Docker Test"
echo ""

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker Desktop и попробуйте снова."
    exit 1
fi

# Проверка переменных окружения
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "❌ OPENROUTER_API_KEY не установлена"
    echo "   Экспортируйте переменную: export OPENROUTER_API_KEY=<ваш_ключ>"
    exit 1
fi

if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    echo "❌ TELEGRAM_BOT_TOKEN не установлена"
    echo "   Экспортируйте переменную: export TELEGRAM_BOT_TOKEN=<ваш_токен>"
    exit 1
fi

echo "✅ Переменные окружения установлены"
echo ""

# Сборка Docker образа
echo "📦 Сборка Docker образа..."
docker build -t openclaw:test .

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при сборке Docker образа"
    exit 1
fi

echo "✅ Docker образ собран"
echo ""

# Запуск контейнера
echo "🚀 Запуск контейнера..."
echo "   Gateway будет доступен на http://localhost:18789"
echo ""
echo "Нажмите Ctrl+C для остановки"
echo ""

docker run \
  -e OPENROUTER_API_KEY="$OPENROUTER_API_KEY" \
  -e TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN" \
  -e OPENCLAW_GATEWAY_TOKEN="test-token-12345" \
  -p 18789:18789 \
  --rm \
  --name openclaw-test \
  openclaw:test

echo ""
echo "✅ Контейнер остановлен"
