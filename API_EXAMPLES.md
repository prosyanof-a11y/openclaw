# 🔌 OpenClaw Gateway API - Примеры

После развертывания на Railway у вас будет доступен WebSocket gateway на адресе:
```
wss://<your-railway-project>.up.railway.app
```

## Health Check

### Проверить что gateway работает

```bash
curl -X GET https://<your-railway-project>.up.railway.app/healthz

# Ответ:
# {"status":"ok","timestamp":"2026-03-27T18:00:00Z"}
```

## Telegram Integration

### Конфигурация вебхука

```bash
# Установить вебхук для получения сообщений
curl -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://<your-railway-project>.up.railway.app/api/telegram/webhook",
    "allowed_updates": ["message", "callback_query"]
  }'

# Проверить вебхук
curl https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getWebhookInfo
```

### Отправить сообщение в Telegram

```bash
# Через OpenClaw Gateway WebSocket
# (требует установленного WebSocket клиента)

{
  "type": "message",
  "channel": "telegram",
  "target": "@channel_name",
  "text": "Привет, это сообщение от OpenClaw!",
  "token": "OPENCLAW_GATEWAY_TOKEN"
}
```

## Agent API

### Запустить агента через gateway

```bash
curl -X POST https://<your-railway-project>.up.railway.app/api/agent \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Что ты можешь делать?",
    "model": "openrouter/auto",
    "temperature": 0.7
  }'
```

### Ответ:
```json
{
  "id": "msg_12345",
  "content": "Я могу помогать с задачами через различные каналы...",
  "model": "openrouter/...",
  "usage": {
    "input_tokens": 25,
    "output_tokens": 150
  }
}
```

## WebSocket Connection

### Подключиться к gateway WebSocket

```javascript
// Node.js пример с ws пакетом
import WebSocket from 'ws';

const ws = new WebSocket('wss://<your-railway-project>.up.railway.app');

ws.on('open', () => {
  // Отправить сообщение
  ws.send(JSON.stringify({
    type: 'ping'
  }));
});

ws.on('message', (data) => {
  console.log('Received:', data);
});

ws.on('error', (error) => {
  console.error('WebSocket error:', error);
});

ws.on('close', () => {
  console.log('Connection closed');
});
```

## Message Routing

### Маршрутизация сообщений между каналами

```bash
# Отправить сообщение в Telegram и получить ответ
curl -X POST https://<your-railway-project>.up.railway.app/api/message/route \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "from": {
      "channel": "telegram",
      "user_id": "123456"
    },
    "to": {
      "channel": "telegram",
      "target": "@target_chat"
    },
    "message": "Переадресованное сообщение",
    "metadata": {
      "forwarded_from": "source_user"
    }
  }'
```

## Configuration API

### Получить текущую конфигурацию

```bash
curl -X GET https://<your-railway-project>.up.railway.app/api/config \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}"

# Ответ:
# {
#   "gateway": {
#     "port": 18789,
#     "hostname": "0.0.0.0"
#   },
#   "channels": {
#     "telegram": {
#       "enabled": true,
#       "token": "***"
#     }
#   },
#   "models": [...]
# }
```

### Обновить конфигурацию

```bash
curl -X PATCH https://<your-railway-project>.up.railway.app/api/config \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "channels": {
      "telegram": {
        "enabled": true
      }
    }
  }'
```

## Status & Monitoring

### Получить статус gateway

```bash
curl -X GET https://<your-railway-project>.up.railway.app/api/status \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}"

# Ответ:
# {
#   "uptime": 3600,
#   "connections": 5,
#   "messages_processed": 247,
#   "channels": {
#     "telegram": {"status": "connected", "users": 12},
#     "discord": {"status": "connected", "users": 8}
#   },
#   "models": {
#     "openrouter": {"status": "available", "latency_ms": 450}
#   }
# }
```

### Получить метрики

```bash
curl -X GET https://<your-railway-project>.up.railway.app/metrics \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}"

# Prometheus-формат метрик (для интеграции с мониторингом)
```

## Error Handling

### Типичные ошибки и решения

```bash
# 401 Unauthorized
# Причина: OPENCLAW_GATEWAY_TOKEN неправильный или не установлен
# Решение: Проверьте переменную окружения в Railway

curl -X GET https://<your-railway-project>.up.railway.app/api/status \
  -H "Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}"

# 502 Bad Gateway
# Причина: Gateway перезагружается или не готов
# Решение: Подождите 30 секунд и попробуйте снова

# 503 Service Unavailable
# Причина: Gateway перегружен или нет подключения к OpenRouter
# Решение: Проверьте OPENROUTER_API_KEY и логи в Railway
```

## Rate Limiting

OpenClaw Gateway использует rate limiting для защиты от злоупотребления:

```
- 100 запросов в минуту на IP
- 1000 запросов в час на gateway token
- WebSocket соединение: 1 MB сообщений в минуту

Если превышен лимит, получите ответ:
HTTP 429 Too Many Requests
X-RateLimit-Reset: 1711610460
```

## Примеры интеграций

### Python интеграция

```python
import requests
import json

GATEWAY_URL = "https://<your-railway-project>.up.railway.app"
GATEWAY_TOKEN = "YOUR_OPENCLAW_GATEWAY_TOKEN"

def send_message(channel, target, message):
    headers = {
        "Authorization": f"Bearer {GATEWAY_TOKEN}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "channel": channel,
        "target": target,
        "message": message
    }
    
    response = requests.post(
        f"{GATEWAY_URL}/api/message/send",
        headers=headers,
        json=payload
    )
    
    return response.json()

# Использование
result = send_message("telegram", "@mychannel", "Hello from Python!")
print(result)
```

### Node.js интеграция

```javascript
import fetch from 'node-fetch';

const GATEWAY_URL = 'https://<your-railway-project>.up.railway.app';
const GATEWAY_TOKEN = 'YOUR_OPENCLAW_GATEWAY_TOKEN';

async function sendMessage(channel, target, message) {
  const response = await fetch(`${GATEWAY_URL}/api/message/send`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${GATEWAY_TOKEN}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      channel,
      target,
      message
    })
  });
  
  return response.json();
}

// Использование
const result = await sendMessage('telegram', '@mychannel', 'Hello from Node.js!');
console.log(result);
```

---

Для более подробной информации см. [OpenClaw API Documentation](https://docs.openclaw.ai/api)
