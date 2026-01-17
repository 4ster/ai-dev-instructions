# Интеграция с Firebase

## Введение

### Что такое Firebase

**Firebase** — это платформа от Google для разработки мобильных и веб-приложений. Она предоставляет готовую инфраструктуру, которую можно использовать без настройки собственных серверов:

| Сервис | Назначение |
|--------|------------|
| **Firestore** | NoSQL база данных в реальном времени |
| **Authentication** | Авторизация пользователей (email, Google, GitHub и др.) |
| **Hosting** | Хостинг статических сайтов и SPA |
| **Cloud Functions** | Серверный код без сервера (serverless) |
| **Storage** | Хранение файлов (изображения, документы) |

### Зачем интегрировать Firebase с AI-агентами

AI-агенты могут значительно ускорить работу с Firebase:

- **Создание структуры базы данных** — описываете схему на естественном языке, агент создаёт коллекции и документы
- **Генерация правил безопасности** — агент пишет Firestore Rules на основе ваших требований
- **Работа с данными** — чтение, запись, обновление без ручного написания запросов
- **Деплой** — развёртывание приложения одной командой
- **Отладка** — агент анализирует логи и помогает находить проблемы

### Что мы настроим

1. Firebase CLI для работы из командной строки
2. MCP сервер Firebase для Claude
3. Базовые операции: Firestore, Auth, Hosting

---

## Предварительные требования

Перед началом убедитесь, что у вас установлены:

- [x] Node.js v18+ ([Инструкция 01](./01-setup-environment.md#nodejs-v18-или-выше))
- [x] Claude Code CLI ([Инструкция 01](./01-setup-environment.md#claude-code-cli))
- [x] Google-аккаунт (для Firebase Console)

### Проверка

```bash
node --version   # v18.0.0 или выше
claude --version # должен быть установлен
```

---

## Создание проекта Firebase

### Через Firebase Console (веб-интерфейс)

1. Перейдите на [console.firebase.google.com](https://console.firebase.google.com/)
2. Нажмите **"Создать проект"** (или "Add project")
3. Введите название проекта (например, `my-ai-app`)
4. Google Analytics — можно отключить для учебных проектов
5. Дождитесь создания проекта

### Через Firebase CLI (после настройки)

После установки и авторизации CLI можно создавать проекты из терминала:

```bash
firebase projects:create my-ai-app --display-name "My AI App"
```

---

## Настройка Firebase CLI

### Установка

```bash
npm install -g firebase-tools
```

### Проверка установки

```bash
firebase --version
```

### Авторизация

```bash
firebase login
```

Откроется браузер для входа через Google-аккаунт. После успешной авторизации вы увидите сообщение в терминале.

### Проверка авторизации

```bash
firebase projects:list
```

Вы должны увидеть список ваших Firebase-проектов.

### Инициализация проекта

В директории вашего проекта выполните:

```bash
firebase init
```

Интерактивный мастер предложит выбрать сервисы. Для начала рекомендуем:

- [x] Firestore
- [x] Hosting
- [ ] Functions (можно добавить позже)
- [ ] Storage (можно добавить позже)

#### Пример ответов на вопросы мастера

```
? Which Firebase features do you want to set up?
  ❯ Firestore, Hosting

? Please select an existing project or create a new one:
  ❯ Use an existing project

? Select a default Firebase project:
  ❯ my-ai-app (My AI App)

? What file should be used for Firestore Rules?
  ❯ firestore.rules (по умолчанию)

? What file should be used for Firestore indexes?
  ❯ firestore.indexes.json (по умолчанию)

? What do you want to use as your public directory?
  ❯ dist (для Vite/React) или build (для Create React App)

? Configure as a single-page app?
  ❯ Yes

? Set up automatic builds and deploys with GitHub?
  ❯ No (можно настроить позже)
```

### Структура после инициализации

```
your-project/
├── firebase.json          # Конфигурация Firebase
├── firestore.rules        # Правила безопасности Firestore
├── firestore.indexes.json # Индексы для запросов
├── .firebaserc            # Связь с проектом Firebase
└── ...
```

---

## Настройка MCP сервера Firebase

MCP сервер позволяет Claude напрямую взаимодействовать с Firebase — читать и записывать данные, управлять проектом.

### Установка

```bash
npm install -g firebase-mcp
```

> **Примечание:** Если официальный `firebase-mcp` недоступен, можно использовать альтернативы или работать через Firebase CLI напрямую.

### Конфигурация для Claude Code CLI

<details>
<summary><strong>Windows</strong></summary>

Отредактируйте файл `%APPDATA%\claude\settings.json`:

```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "firebase-mcp"],
      "env": {
        "FIREBASE_PROJECT_ID": "your-project-id",
        "GOOGLE_APPLICATION_CREDENTIALS": "C:\\path\\to\\service-account.json"
      }
    }
  }
}
```

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

Отредактируйте файл `~/.config/claude/settings.json`:

```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "firebase-mcp"],
      "env": {
        "FIREBASE_PROJECT_ID": "your-project-id",
        "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json"
      }
    }
  }
}
```

</details>

### Получение Service Account Key

Для работы MCP сервера нужен ключ сервисного аккаунта:

1. Откройте [Firebase Console](https://console.firebase.google.com/)
2. Выберите ваш проект
3. Перейдите в **Project Settings** (значок шестерёнки)
4. Вкладка **Service accounts**
5. Нажмите **Generate new private key**
6. Сохраните JSON-файл в безопасное место

> **Важно:** Никогда не коммитьте этот файл в Git! Добавьте его в `.gitignore`.

### Альтернатива: работа через Firebase CLI

Если MCP сервер недоступен, Claude может работать с Firebase через CLI. В этом случае достаточно авторизации через `firebase login`.

---

## Работа с Firestore через AI-агента

### Что такое Firestore

**Firestore** — это NoSQL база данных, организованная в виде:
- **Коллекции** (collections) — группы документов
- **Документы** (documents) — записи с полями и значениями

Пример структуры:
```
users/                    # коллекция
  ├── user123/           # документ
  │   ├── name: "Иван"
  │   ├── email: "ivan@example.com"
  │   └── createdAt: Timestamp
  └── user456/
      └── ...
```

### Примеры запросов к Claude

#### Создание структуры базы данных

**Вы:**
> Создай структуру Firestore для приложения заметок. Нужны пользователи и их заметки. У заметки есть заголовок, текст, дата создания и теги.

**Claude создаст:**
- Коллекцию `users` с документами пользователей
- Подколлекцию `notes` внутри каждого пользователя
- Правила безопасности

#### Добавление данных

**Вы:**
> Добавь тестового пользователя с email test@example.com и создай ему 3 заметки

#### Чтение данных

**Вы:**
> Покажи все заметки пользователя с id "user123", отсортированные по дате

#### Генерация правил безопасности

**Вы:**
> Напиши правила Firestore: пользователь может читать и писать только свои заметки, а профиль может читать кто угодно

**Claude сгенерирует `firestore.rules`:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Профили пользователей — чтение для всех, запись только владельцу
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;

      // Заметки — только владелец
      match /notes/{noteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### Деплой правил

```bash
firebase deploy --only firestore:rules
```

---

## Firebase Authentication через AI-агента

### Настройка провайдеров авторизации

1. Откройте Firebase Console → Authentication
2. Вкладка **Sign-in method**
3. Включите нужные провайдеры:
   - Email/Password
   - Google
   - GitHub (требует настройки OAuth)

### Примеры запросов к Claude

#### Генерация кода авторизации

**Вы:**
> Напиши React-компонент для входа через email и Google с использованием Firebase Auth

**Claude создаст:**
- Компонент формы входа
- Обработчики для email/password и Google Sign-In
- Обработку ошибок

#### Защита маршрутов

**Вы:**
> Создай HOC или хук для защиты маршрутов — если пользователь не авторизован, редирект на /login

### Пример сгенерированного кода

```typescript
// hooks/useAuth.ts
import { useState, useEffect } from 'react';
import { onAuthStateChanged, User } from 'firebase/auth';
import { auth } from '../firebase';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setUser(user);
      setLoading(false);
    });

    return unsubscribe;
  }, []);

  return { user, loading };
}
```

---

## Firebase Hosting

### Что такое Firebase Hosting

Firebase Hosting — это быстрый и безопасный хостинг для статических сайтов и SPA (Single Page Applications). Особенности:

- Бесплатный SSL-сертификат
- Глобальная CDN
- Автоматическое кеширование
- Поддержка кастомных доменов

### Деплой через CLI

#### Сборка проекта

```bash
npm run build
```

#### Деплой

```bash
firebase deploy --only hosting
```

После деплоя вы получите URL вида: `https://your-project.web.app`

### Примеры запросов к Claude

**Вы:**
> Задеплой текущий проект на Firebase Hosting

**Claude выполнит:**
1. Проверит наличие `firebase.json`
2. Запустит сборку (`npm run build`)
3. Выполнит `firebase deploy --only hosting`
4. Вернёт URL развёрнутого приложения

**Вы:**
> Настрой preview-каналы для PR

**Claude настроит:**
```bash
firebase hosting:channel:deploy preview-feature-123
```

---

## Практические примеры

### Пример 1: Создание простого TODO-приложения

**Запрос к Claude:**

> Создай структуру Firebase для TODO-приложения:
> - Пользователи могут создавать списки задач
> - У каждой задачи: название, статус (done/pending), приоритет, дедлайн
> - Пользователь видит только свои задачи
>
> Сгенерируй: структуру Firestore, правила безопасности, TypeScript-типы

### Пример 2: Миграция данных

**Запрос к Claude:**

> У меня есть JSON-файл с 100 пользователями (users.json). Загрузи их в коллекцию users в Firestore. Формат:
> ```json
> [{"name": "Иван", "email": "ivan@test.com"}, ...]
> ```

### Пример 3: Аналитика и отчёты

**Запрос к Claude:**

> Посчитай количество пользователей, зарегистрированных за последний месяц, и выведи топ-5 по количеству созданных заметок

---

## Работа с Firebase через CLI (без MCP)

Если MCP сервер Firebase недоступен, Claude может работать через Firebase CLI напрямую.

### Полезные команды

| Команда | Описание |
|---------|----------|
| `firebase projects:list` | Список проектов |
| `firebase use <project-id>` | Переключение между проектами |
| `firebase deploy` | Полный деплой |
| `firebase deploy --only hosting` | Деплой только хостинга |
| `firebase deploy --only firestore:rules` | Деплой только правил |
| `firebase emulators:start` | Запуск локальных эмуляторов |
| `firebase firestore:delete --all-collections` | Удаление всех данных (осторожно!) |

### Локальная разработка с эмуляторами

Firebase Emulator Suite позволяет тестировать приложение локально без затрат:

```bash
firebase init emulators
firebase emulators:start
```

Эмуляторы доступны по адресам:
- Firestore: `http://localhost:8080`
- Auth: `http://localhost:9099`
- Hosting: `http://localhost:5000`

---

## Troubleshooting

### Ошибка: "Permission denied"

**Причина:** Неправильные правила безопасности Firestore.

**Решение:**
1. Проверьте `firestore.rules`
2. Убедитесь, что пользователь авторизован
3. Временно для отладки можно разрешить всё (НЕ для продакшена!):
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```

### Ошибка: "Firebase project not found"

**Причина:** Неверный project ID или не выбран проект.

**Решение:**
```bash
firebase projects:list           # Проверить доступные проекты
firebase use your-project-id     # Выбрать проект
```

### Ошибка: "Command not found: firebase"

**Причина:** Firebase CLI не установлен или не в PATH.

**Решение:**
```bash
npm install -g firebase-tools
```

Перезапустите терминал после установки.

### MCP сервер не подключается

**Проверьте:**
1. Правильность пути к `service-account.json`
2. Корректность `FIREBASE_PROJECT_ID`
3. Наличие прав у сервисного аккаунта

**Диагностика:**
```bash
claude
# В интерактивном режиме:
/mcp
```

---

## Безопасность

### Что НЕЛЬЗЯ делать

- ❌ Коммитить `service-account.json` в Git
- ❌ Использовать `allow read, write: if true` в продакшене
- ❌ Хранить API-ключи в коде

### Что НУЖНО делать

- ✅ Добавить `service-account.json` в `.gitignore`
- ✅ Использовать переменные окружения для ключей
- ✅ Настроить правила безопасности для каждой коллекции
- ✅ Включить App Check для защиты от злоупотреблений

### Пример .gitignore

```gitignore
# Firebase
service-account.json
*-service-account.json
firebase-debug.log
.firebase/

# Environment
.env
.env.local
```

---

## Чек-лист готовности

- [ ] Firebase CLI установлен (`firebase --version`)
- [ ] Авторизация выполнена (`firebase login`)
- [ ] Проект создан в Firebase Console
- [ ] Проект инициализирован локально (`firebase init`)
- [ ] Firestore включён в консоли
- [ ] Правила безопасности настроены
- [ ] (Опционально) MCP сервер настроен
- [ ] (Опционально) Service account key получен

---

## Следующие шаги

- [Инструкция 04: Продвинутые MCP серверы](04-advanced-mcp.md) — fetch, puppeteer, postgres и другие
- [Инструкция 05: Настройка WSL для Windows](05-wsl-setup.md) *(опционально, только для Windows)*
- [Firebase Documentation](https://firebase.google.com/docs) — официальная документация

---

*Последнее обновление: январь 2025*
