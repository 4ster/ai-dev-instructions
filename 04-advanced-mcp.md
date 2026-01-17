# Продвинутые MCP серверы

## Введение

### Что такое MCP

**MCP (Model Context Protocol)** — это открытый протокол, позволяющий AI-моделям безопасно взаимодействовать с внешними системами. MCP серверы выступают "мостами" между AI-агентом и различными сервисами.

### Архитектура MCP

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   AI-агент      │────▶│   MCP сервер    │────▶│  Внешний сервис │
│ (Claude, etc.)  │◀────│   (мост)        │◀────│  (API, DB, FS)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**Как это работает:**
1. AI-агент отправляет запрос MCP серверу
2. MCP сервер преобразует запрос в формат внешнего сервиса
3. Внешний сервис возвращает данные
4. MCP сервер передаёт данные AI-агенту

### Преимущества MCP

| Аспект | Без MCP | С MCP |
|--------|---------|-------|
| **Доступ к данным** | Только через команды терминала | Прямой доступ к API и базам |
| **Безопасность** | AI выполняет произвольные команды | Контролируемый набор операций |
| **Контекст** | Ограничен текстовым выводом | Структурированные данные |
| **Скорость** | Парсинг текстового вывода | Нативная работа с данными |

### Что мы настроим

В этой инструкции рассмотрим:

| Сервер | Назначение |
|--------|------------|
| **fetch** | HTTP-запросы к любым API |
| **puppeteer** | Браузерная автоматизация, скриншоты |
| **postgres** | Работа с PostgreSQL |
| **sqlite** | Работа с SQLite базами |
| **brave-search** | Веб-поиск |
| **telegram** | Интеграция с Telegram |
| **sequential-thinking** | Улучшенное планирование задач |

### Предварительные требования

- Node.js v18+ установлен
- Claude Code CLI или Claude Desktop настроен
- Базовые MCP серверы работают (см. [Инструкция 01](01-setup-environment.md))

---

## Общие принципы настройки

### Структура конфигурации

Все MCP серверы настраиваются в файле `settings.json`:

<details>
<summary><strong>Windows</strong></summary>

**Claude Code CLI:** `%APPDATA%\claude\settings.json`

**Claude Desktop:** `%APPDATA%\Claude\claude_desktop_config.json`

</details>

<details>
<summary><strong>macOS</strong></summary>

**Claude Code CLI:** `~/.config/claude/settings.json`

**Claude Desktop:** `~/Library/Application Support/Claude/claude_desktop_config.json`

</details>

<details>
<summary><strong>Linux</strong></summary>

**Claude Code CLI:** `~/.config/claude/settings.json`

</details>

### Формат конфигурации

```json
{
  "mcpServers": {
    "имя-сервера": {
      "command": "команда для запуска",
      "args": ["аргументы", "командной", "строки"],
      "env": {
        "ПЕРЕМЕННАЯ": "значение"
      }
    }
  }
}
```

### Добавление нескольких серверов

```json
{
  "mcpServers": {
    "сервер1": { ... },
    "сервер2": { ... },
    "сервер3": { ... }
  }
}
```

> **Важно:** После изменения конфигурации перезапустите Claude Code CLI или Claude Desktop.

---

## Fetch — HTTP-запросы

### Назначение

MCP сервер `fetch` позволяет AI-агенту делать HTTP-запросы к любым API и веб-страницам:

- Получать данные из REST API
- Загружать содержимое веб-страниц
- Отправлять данные на серверы
- Работать с webhooks

### Установка

```bash
npm install -g @anthropic-ai/mcp-server-fetch
```

### Конфигурация

```json
{
  "mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"]
    }
  }
}
```

### Примеры использования

**Запрос к публичному API:**
```
Получи текущую погоду в Москве через API openweathermap.org
```

**Парсинг веб-страницы:**
```
Загрузи страницу https://example.com и извлеки все заголовки
```

**Работа с REST API:**
```
Отправь POST-запрос на https://api.example.com/data с JSON-телом
```

### Ограничения

- Некоторые сайты блокируют автоматические запросы
- Нет поддержки JavaScript-рендеринга (для этого используйте Puppeteer)
- Таймауты на долгие запросы

---

## Puppeteer — браузерная автоматизация

### Назначение

MCP сервер `puppeteer` запускает headless-браузер Chrome и позволяет:

- Делать скриншоты веб-страниц
- Взаимодействовать с JavaScript-приложениями
- Заполнять формы и кликать по элементам
- Извлекать данные из SPA (Single Page Applications)

### Установка

```bash
npm install -g @anthropic-ai/mcp-server-puppeteer
```

> **Примечание:** При первом запуске может потребоваться скачивание Chromium (~150 МБ).

### Конфигурация

```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-puppeteer"]
    }
  }
}
```

### Расширенная конфигурация

```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-puppeteer"],
      "env": {
        "PUPPETEER_HEADLESS": "true",
        "PUPPETEER_TIMEOUT": "30000"
      }
    }
  }
}
```

### Примеры использования

**Скриншот страницы:**
```
Сделай скриншот главной страницы google.com
```

**Извлечение данных из SPA:**
```
Открой страницу https://app.example.com, дождись загрузки данных и извлеки таблицу с пользователями
```

**Автоматизация действий:**
```
Зайди на сайт, заполни форму поиска словом "MCP" и сделай скриншот результатов
```

### Сценарии применения

| Задача | Fetch | Puppeteer |
|--------|-------|-----------|
| Получить HTML статической страницы | ✓ | ✓ |
| Получить данные из SPA | ✗ | ✓ |
| Сделать скриншот | ✗ | ✓ |
| Заполнить форму | ✗ | ✓ |
| Скорость работы | Быстро | Медленнее |
| Потребление памяти | Минимальное | Значительное |

---

## PostgreSQL — работа с базой данных

### Назначение

MCP сервер `postgres` позволяет AI-агенту:

- Выполнять SQL-запросы
- Анализировать структуру базы данных
- Создавать и модифицировать таблицы
- Работать с данными

### Установка

```bash
npm install -g @anthropic-ai/mcp-server-postgres
```

### Предварительные требования

Установите PostgreSQL, если ещё не установлен:

<details>
<summary><strong>Windows</strong></summary>

1. Скачайте установщик с [postgresql.org](https://www.postgresql.org/download/windows/)
2. Запустите и следуйте инструкциям
3. Запомните пароль для пользователя `postgres`

Или через winget:
```powershell
winget install PostgreSQL.PostgreSQL
```

</details>

<details>
<summary><strong>macOS</strong></summary>

```bash
brew install postgresql@15
brew services start postgresql@15
```

</details>

<details>
<summary><strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

</details>

### Конфигурация

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:password@localhost:5432/database"
      }
    }
  }
}
```

### Формат строки подключения

```
postgresql://[user]:[password]@[host]:[port]/[database]
```

**Примеры:**
```
postgresql://postgres:mypassword@localhost:5432/myapp
postgresql://admin:secret@db.example.com:5432/production
```

### Примеры использования

**Анализ структуры:**
```
Покажи все таблицы в базе данных и их структуру
```

**Выполнение запросов:**
```
Выбери всех пользователей, зарегистрированных за последний месяц
```

**Создание таблиц:**
```
Создай таблицу products с полями: id, name, price, created_at
```

**Анализ данных:**
```
Проанализируй таблицу orders: сколько заказов в день, средний чек, топ-5 товаров
```

### Безопасность

> **Важно:** Для продакшен баз данных создавайте отдельного пользователя с ограниченными правами:

```sql
-- Создать пользователя только для чтения
CREATE USER claude_reader WITH PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE myapp TO claude_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO claude_reader;
```

---

## SQLite — локальные базы данных

### Назначение

MCP сервер `sqlite` позволяет работать с локальными SQLite базами:

- Анализировать существующие .sqlite / .db файлы
- Создавать новые базы данных
- Выполнять SQL-запросы
- Экспортировать данные

### Установка

```bash
npm install -g @anthropic-ai/mcp-server-sqlite
```

### Конфигурация

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sqlite", "/path/to/database.db"]
    }
  }
}
```

### Работа с несколькими базами

Можно настроить несколько экземпляров:

```json
{
  "mcpServers": {
    "sqlite-app": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sqlite", "/path/to/app.db"]
    },
    "sqlite-analytics": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sqlite", "/path/to/analytics.db"]
    }
  }
}
```

### Примеры использования

**Анализ базы:**
```
Открой базу данных app.db и покажи структуру всех таблиц
```

**Создание базы для проекта:**
```
Создай SQLite базу данных для блога с таблицами: posts, comments, users
```

**Миграция данных:**
```
Экспортируй данные из таблицы users в CSV-формат
```

### Когда использовать SQLite vs PostgreSQL

| Критерий | SQLite | PostgreSQL |
|----------|--------|------------|
| Установка | Не требуется | Требуется сервер |
| Многопользовательский доступ | Ограничен | Полный |
| Размер данных | До нескольких ГБ | Без ограничений |
| Локальная разработка | Идеально | Избыточно |
| Продакшен | Малые проекты | Рекомендуется |

---

## Brave Search — веб-поиск

### Назначение

MCP сервер `brave-search` даёт AI-агенту возможность искать информацию в интернете:

- Поиск актуальной информации
- Исследование темы
- Проверка фактов
- Поиск документации

### Получение API-ключа

1. Перейдите на [brave.com/search/api](https://brave.com/search/api/)
2. Зарегистрируйтесь или войдите
3. Создайте приложение
4. Скопируйте API-ключ

> **Примечание:** Brave Search API имеет бесплатный тариф с ограничением запросов.

### Установка

```bash
npm install -g @anthropic-ai/mcp-server-brave-search
```

### Конфигурация

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "BSA..."
      }
    }
  }
}
```

### Примеры использования

**Поиск информации:**
```
Найди последние новости о релизе React 19
```

**Исследование темы:**
```
Найди лучшие практики по настройке CI/CD для Node.js проектов
```

**Поиск документации:**
```
Найди официальную документацию по Prisma ORM
```

### Альтернативы

Если вам нужен поиск без отдельного API-ключа, Claude Code CLI имеет встроенную функцию веб-поиска через WebSearch tool.

---

## Telegram — интеграция с мессенджером

### Назначение

MCP сервер для Telegram позволяет AI-агенту:

- Читать сообщения из чатов и каналов
- Отправлять сообщения
- Управлять группами
- Работать с медиафайлами и контактами

> **Примечание:** Официального MCP сервера для Telegram от Anthropic нет. Мы используем community-сервер [telegram-mcp](https://github.com/chigwell/telegram-mcp) на базе Telethon.

### Предварительные требования

- Python 3.10+
- Аккаунт Telegram
- API credentials от Telegram

### Получение Telegram API credentials

1. Перейдите на [my.telegram.org](https://my.telegram.org/)
2. Войдите с номером телефона
3. Выберите **API development tools**
4. Создайте новое приложение:
   - App title: `Claude MCP` (любое название)
   - Short name: `claudemcp` (любое)
   - Platform: `Desktop`
5. Скопируйте **App api_id** и **App api_hash**

### Установка

```bash
# Через pip
pip install telegram-mcp

# Или через uvx (рекомендуется)
uvx telegram-mcp
```

### Конфигурация

<details>
<summary><strong>Windows</strong></summary>

```json
{
  "mcpServers": {
    "telegram": {
      "command": "uvx",
      "args": ["telegram-mcp"],
      "env": {
        "TELEGRAM_API_ID": "12345678",
        "TELEGRAM_API_HASH": "abcdef1234567890abcdef1234567890"
      }
    }
  }
}
```

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

```json
{
  "mcpServers": {
    "telegram": {
      "command": "uvx",
      "args": ["telegram-mcp"],
      "env": {
        "TELEGRAM_API_ID": "12345678",
        "TELEGRAM_API_HASH": "abcdef1234567890abcdef1234567890"
      }
    }
  }
}
```

</details>

### Первый запуск

При первом запуске потребуется авторизация:

1. Запустите Claude Code
2. При первом обращении к Telegram сервер запросит номер телефона
3. Введите код подтверждения из Telegram
4. Сессия сохранится для последующих запусков

### Примеры использования

**Чтение сообщений:**
```
Покажи последние 10 сообщений из чата с @username
```

**Отправка сообщения:**
```
Отправь сообщение "Привет!" в чат с @username
```

**Список чатов:**
```
Покажи список моих недавних чатов в Telegram
```

**Поиск:**
```
Найди в Telegram все сообщения, содержащие слово "проект"
```

### Альтернативные серверы

| Сервер | Особенности |
|--------|-------------|
| [telegram-mcp](https://github.com/chigwell/telegram-mcp) | Полнофункциональный, на базе Telethon |
| [mcp-telegram](https://github.com/sparfenyuk/mcp-telegram) | Только чтение, MTProto |
| [Telegram-Bot-MCP](https://github.com/SmartManoj/Telegram-Bot-MCP) | Для ботов, простая настройка |

### Безопасность

> **Важно:**
> - API credentials дают полный доступ к вашему аккаунту Telegram
> - Не коммитьте `api_id` и `api_hash` в репозиторий
> - Храните session-файл в безопасном месте
> - Используйте отдельный аккаунт для тестирования

---

## Sequential Thinking — улучшенное планирование

### Назначение

MCP сервер `sequential-thinking` помогает AI-агенту:

- Разбивать сложные задачи на шаги
- Планировать последовательность действий
- Отслеживать прогресс выполнения
- Корректировать план на ходу

### Установка

```bash
npm install -g @anthropic-ai/mcp-server-sequential-thinking
```

### Конфигурация

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"]
    }
  }
}
```

### Когда полезен

- Многошаговые задачи (рефакторинг большого модуля)
- Задачи с зависимостями (сначала A, потом B)
- Исследовательские задачи (анализ с последующими действиями)

### Пример использования

```
Мне нужно мигрировать проект с JavaScript на TypeScript.
Используй sequential-thinking для планирования:
1. Проанализируй текущую структуру
2. Определи порядок миграции файлов
3. Выполни миграцию поэтапно
```

---

## Комплексная конфигурация

### Пример полной настройки

Вот пример конфигурации с несколькими MCP серверами:

<details>
<summary><strong>Windows</strong></summary>

Файл: `%APPDATA%\claude\settings.json`

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "C:\\Users\\Username\\Projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxxxxxxxxxx"
      }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"]
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-puppeteer"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://postgres:password@localhost:5432/mydb"
      }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "BSA_xxxxxxxxxxxx"
      }
    },
    "telegram": {
      "command": "uvx",
      "args": ["telegram-mcp"],
      "env": {
        "TELEGRAM_API_ID": "12345678",
        "TELEGRAM_API_HASH": "abcdef1234567890abcdef1234567890"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"]
    }
  }
}
```

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

Файл: `~/.config/claude/settings.json`

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "/home/username/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxxxxxxxxxx"
      }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"]
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-puppeteer"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://postgres:password@localhost:5432/mydb"
      }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "BSA_xxxxxxxxxxxx"
      }
    },
    "telegram": {
      "command": "uvx",
      "args": ["telegram-mcp"],
      "env": {
        "TELEGRAM_API_ID": "12345678",
        "TELEGRAM_API_HASH": "abcdef1234567890abcdef1234567890"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"]
    }
  }
}
```

</details>

---

## Создание собственного MCP сервера

### Когда это нужно

- Интеграция с внутренним API компании
- Работа с нестандартными сервисами
- Специфические требования безопасности

### Структура MCP сервера

MCP сервер — это Node.js приложение, реализующее протокол MCP:

```
my-mcp-server/
├── package.json
├── src/
│   └── index.ts
└── tsconfig.json
```

### Минимальный пример

```typescript
// src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server(
  { name: "my-server", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// Регистрация инструмента
server.setRequestHandler("tools/list", async () => ({
  tools: [
    {
      name: "hello",
      description: "Возвращает приветствие",
      inputSchema: {
        type: "object",
        properties: {
          name: { type: "string", description: "Имя для приветствия" }
        },
        required: ["name"]
      }
    }
  ]
}));

// Обработка вызова инструмента
server.setRequestHandler("tools/call", async (request) => {
  if (request.params.name === "hello") {
    const name = request.params.arguments.name;
    return { content: [{ type: "text", text: `Привет, ${name}!` }] };
  }
  throw new Error("Unknown tool");
});

// Запуск сервера
const transport = new StdioServerTransport();
server.connect(transport);
```

### Ресурсы для разработки

- [MCP SDK документация](https://github.com/anthropics/mcp)
- [Примеры серверов](https://github.com/anthropics/mcp-servers)
- [Спецификация протокола](https://spec.modelcontextprotocol.io/)

---

## Устранение проблем

### Сервер не запускается

**Проверьте:**
1. Node.js установлен: `node --version`
2. Пакет установлен: `npm list -g @anthropic-ai/mcp-server-xxx`
3. JSON-синтаксис корректен (проверьте запятые и кавычки)

**Переустановка пакета:**
```bash
npm uninstall -g @anthropic-ai/mcp-server-fetch
npm install -g @anthropic-ai/mcp-server-fetch
```

### Ошибки авторизации

**Проверьте:**
1. Токены/ключи актуальны
2. Права доступа достаточны
3. Переменные окружения заданы правильно

**Тест токена GitHub:**
```bash
curl -H "Authorization: token ghp_xxx" https://api.github.com/user
```

### Сервер не отображается в /mcp

1. Перезапустите Claude Code CLI
2. Проверьте путь к конфигурационному файлу
3. Проверьте JSON на ошибки: [jsonlint.com](https://jsonlint.com/)

### Puppeteer не запускается

<details>
<summary><strong>Windows</strong></summary>

Может потребоваться установка Visual C++ Redistributable:
```powershell
winget install Microsoft.VCRedist.2015+.x64
```

</details>

<details>
<summary><strong>Linux</strong></summary>

Установите зависимости для Chromium:
```bash
sudo apt install -y libgbm1 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 libxcomposite1 libxrandr2
```

</details>

### PostgreSQL connection refused

1. Проверьте, что PostgreSQL запущен:
   ```bash
   # Linux/macOS
   pg_isready

   # Windows (PowerShell)
   Get-Service postgresql*
   ```

2. Проверьте строку подключения
3. Убедитесь, что пользователь и база существуют

---

## Чек-лист

### Базовые серверы
- [ ] filesystem настроен
- [ ] github настроен

### Продвинутые серверы (по необходимости)
- [ ] fetch — для HTTP-запросов
- [ ] puppeteer — для браузерной автоматизации
- [ ] postgres — для работы с PostgreSQL
- [ ] sqlite — для локальных баз данных
- [ ] brave-search — для веб-поиска
- [ ] telegram — для интеграции с Telegram
- [ ] sequential-thinking — для сложного планирования

### Проверка
- [ ] Все настроенные серверы отображаются в `/mcp`
- [ ] Тестовые запросы к серверам работают

---

## Полезные ссылки

- [Официальный репозиторий MCP серверов](https://github.com/anthropics/mcp-servers)
- [MCP SDK](https://github.com/anthropics/mcp)
- [Спецификация протокола](https://spec.modelcontextprotocol.io/)
- [Каталог community-серверов](https://github.com/punkpeye/awesome-mcp-servers)

---

*Последнее обновление: январь 2025*
