# Работа с GitHub через AI-агентов

## Введение

### Зачем AI-агенту доступ к GitHub

AI-агенты становятся значительно полезнее, когда могут не только писать код, но и выполнять полный цикл разработки:

- **Создавать коммиты** с осмысленными сообщениями
- **Открывать Pull Request** с описанием изменений
- **Просматривать Issues** и понимать контекст задачи
- **Анализировать код-ревью** и вносить правки
- **Управлять релизами** и тегами

### Что мы настроим

| Инструмент | Возможности |
|------------|-------------|
| **GitHub CLI (gh)** | Базовая работа с GitHub из терминала |
| **Git** | Коммиты, ветки, слияния |
| **MCP сервер github** | Расширенный доступ для AI-агентов |

### Предварительные требования

Убедитесь, что у вас установлены и настроены:

- Git (см. [Инструкция 01](01-setup-environment.md))
- GitHub CLI (см. [Инструкция 01](01-setup-environment.md))
- Claude Code CLI или Claude Desktop
- Аккаунт на GitHub

---

## Основы Git для AI-разработки

### Базовые концепции

Если вы новичок в Git, вот ключевые понятия:

| Термин | Описание |
|--------|----------|
| **Репозиторий (repo)** | Папка проекта, отслеживаемая Git |
| **Коммит** | Сохранённое состояние файлов с описанием изменений |
| **Ветка (branch)** | Параллельная линия разработки |
| **Pull Request (PR)** | Запрос на слияние изменений из одной ветки в другую |
| **Remote** | Удалённый репозиторий (обычно на GitHub) |
| **Clone** | Копирование удалённого репозитория на локальный компьютер |

### Создание репозитория

#### Новый проект

```bash
# Создать папку и инициализировать Git
mkdir my-project
cd my-project
git init

# Создать первый файл
echo "# My Project" > README.md

# Добавить файл в отслеживание и сделать коммит
git add README.md
git commit -m "Initial commit"
```

#### Клонирование существующего

```bash
# Через HTTPS
git clone https://github.com/username/repository.git

# Через SSH (если настроен)
git clone git@github.com:username/repository.git

# Через GitHub CLI
gh repo clone username/repository
```

### Базовый рабочий процесс

```bash
# 1. Проверить статус (какие файлы изменены)
git status

# 2. Посмотреть изменения
git diff

# 3. Добавить файлы для коммита
git add .                    # Все файлы
git add src/component.tsx    # Конкретный файл

# 4. Создать коммит
git commit -m "Добавил новый компонент"

# 5. Отправить на GitHub
git push
```

---

## Настройка GitHub CLI

### Проверка установки

```bash
gh --version
```

Если не установлен, см. [Инструкция 01](01-setup-environment.md).

### Авторизация

```bash
gh auth login
```

Выберите:
1. `GitHub.com`
2. `HTTPS` (рекомендуется) или `SSH`
3. `Login with a web browser`

Следуйте инструкциям в браузере.

### Проверка авторизации

```bash
gh auth status
```

Вы должны увидеть:
```
github.com
  ✓ Logged in to github.com as username
  ✓ Git operations configured to use https protocol
  ✓ Token: ghp_****
```

---

## Работа с репозиториями через gh

### Создание репозитория

```bash
# Создать публичный репозиторий
gh repo create my-new-project --public

# Создать приватный репозиторий
gh repo create my-private-project --private

# Создать и сразу клонировать
gh repo create my-project --public --clone

# Создать из текущей папки
gh repo create --source=. --public
```

### Клонирование

```bash
# Клонировать свой репозиторий
gh repo clone my-repo

# Клонировать чужой репозиторий
gh repo clone owner/repo

# Форкнуть и клонировать
gh repo fork owner/repo --clone
```

### Просмотр информации

```bash
# Открыть репозиторий в браузере
gh repo view --web

# Показать информацию в терминале
gh repo view

# Список ваших репозиториев
gh repo list
```

---

## Работа с Issues

### Что такое Issues

Issues (задачи) — это способ отслеживания:
- Багов
- Новых функций
- Вопросов
- Задач для выполнения

### Просмотр Issues

```bash
# Список открытых issues
gh issue list

# Список всех issues (включая закрытые)
gh issue list --state all

# Фильтр по меткам
gh issue list --label "bug"

# Просмотр конкретного issue
gh issue view 42
```

### Создание Issue

```bash
# Интерактивное создание
gh issue create

# С параметрами
gh issue create --title "Баг в авторизации" --body "При входе появляется ошибка 500"

# С метками и исполнителем
gh issue create --title "Добавить тёмную тему" --label "enhancement" --assignee @me
```

### Управление Issues

```bash
# Закрыть issue
gh issue close 42

# Переоткрыть issue
gh issue reopen 42

# Добавить комментарий
gh issue comment 42 --body "Исправлено в PR #45"

# Назначить на себя
gh issue edit 42 --add-assignee @me
```

---

## Работа с Pull Requests

### Что такое Pull Request

Pull Request (PR) — это запрос на внесение изменений из одной ветки в другую. Типичный процесс:

1. Создать ветку для новой функции
2. Внести изменения и закоммитить
3. Создать PR для ревью
4. После одобрения — слить (merge) в основную ветку

### Создание ветки и PR

```bash
# 1. Создать новую ветку
git checkout -b feature/add-dark-mode

# 2. Внести изменения в код...

# 3. Закоммитить
git add .
git commit -m "Добавил тёмную тему"

# 4. Отправить ветку на GitHub
git push -u origin feature/add-dark-mode

# 5. Создать PR
gh pr create --title "Добавил тёмную тему" --body "Реализована тёмная тема согласно issue #12"
```

### Интерактивное создание PR

```bash
gh pr create
```

GitHub CLI предложит:
1. Выбрать базовую ветку (обычно `main`)
2. Ввести заголовок
3. Ввести описание
4. Выбрать ревьюеров (опционально)

### Просмотр PR

```bash
# Список открытых PR
gh pr list

# Просмотр конкретного PR
gh pr view 45

# Открыть PR в браузере
gh pr view 45 --web

# Посмотреть diff
gh pr diff 45
```

### Ревью PR

```bash
# Одобрить PR
gh pr review 45 --approve

# Запросить изменения
gh pr review 45 --request-changes --body "Нужно добавить тесты"

# Оставить комментарий
gh pr review 45 --comment --body "Выглядит хорошо, но есть вопрос..."
```

### Слияние PR

```bash
# Обычное слияние (merge commit)
gh pr merge 45

# Squash (объединить все коммиты в один)
gh pr merge 45 --squash

# Rebase
gh pr merge 45 --rebase

# Автоматически удалить ветку после слияния
gh pr merge 45 --delete-branch
```

---

## Настройка MCP сервера GitHub

MCP сервер даёт AI-агентам расширенный доступ к GitHub без необходимости вызывать команды `gh` напрямую.

### Создание Personal Access Token

1. Перейдите на [github.com/settings/tokens](https://github.com/settings/tokens)
2. Нажмите **Generate new token** → **Generate new token (classic)**
3. Дайте токену понятное имя: `Claude MCP Server`
4. Установите срок действия (рекомендуется 90 дней)
5. Выберите scopes:

| Scope | Зачем |
|-------|-------|
| `repo` | Полный доступ к репозиториям |
| `read:org` | Чтение информации об организациях |
| `read:user` | Чтение профиля пользователя |
| `workflow` | Управление GitHub Actions (опционально) |

6. Нажмите **Generate token**
7. **Скопируйте токен** — он показывается только один раз!

### Конфигурация MCP сервера

<details>
<summary><strong>Windows</strong></summary>

Откройте файл `%APPDATA%\claude\settings.json` и добавьте:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_ваш_токен_здесь"
      }
    }
  }
}
```

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

Откройте файл `~/.config/claude/settings.json` и добавьте:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_ваш_токен_здесь"
      }
    }
  }
}
```

</details>

### Альтернатива: использование gh auth token

Вместо создания отдельного токена можно использовать токен из GitHub CLI:

```bash
# Получить токен из gh
gh auth token
```

И использовать его в конфигурации MCP.

### Проверка работоспособности

1. Перезапустите Claude Code CLI:
   ```bash
   claude
   ```

2. Проверьте подключение MCP серверов:
   ```
   /mcp
   ```

3. Попросите Claude выполнить действие с GitHub:
   ```
   Покажи список моих репозиториев на GitHub
   ```

---

## Практические сценарии с AI-агентом

### Сценарий 1: Создание проекта с нуля

Попросите Claude:

```
Создай новый проект на GitHub:
- Название: my-react-app
- Приватный репозиторий
- Инициализируй с README.md
- Добавь .gitignore для Node.js
- Клонируй локально в ~/projects/
```

### Сценарий 2: Работа с Issues

```
Посмотри открытые issues в репозитории my-project.
Создай новый issue:
- Заголовок: "Добавить валидацию форм"
- Описание: нужно добавить валидацию email и пароля
- Метка: enhancement
```

### Сценарий 3: Создание PR

```
Создай новую ветку feature/form-validation.
Реализуй валидацию форм из issue #15.
Создай PR с описанием изменений.
```

### Сценарий 4: Code Review

```
Проанализируй PR #23 в репозитории my-project:
- Проверь код на потенциальные проблемы
- Оцени читаемость
- Предложи улучшения
```

### Сценарий 5: Исправление бага

```
В issue #42 описан баг с авторизацией.
Найди причину, исправь и создай PR с фиксом.
Свяжи PR с issue, чтобы он автоматически закрылся при мерже.
```

---

## Полезные команды gh

### Быстрые действия

```bash
# Открыть репозиторий в браузере
gh browse

# Открыть конкретный файл
gh browse src/index.ts

# Открыть issues
gh browse --issues

# Открыть PR
gh browse --pulls
```

### Работа с GitHub Actions

```bash
# Список workflow запусков
gh run list

# Просмотр конкретного запуска
gh run view 123456

# Просмотр логов
gh run view 123456 --log

# Перезапуск workflow
gh run rerun 123456
```

### Работа с релизами

```bash
# Список релизов
gh release list

# Создать релиз
gh release create v1.0.0 --title "Первый релиз" --notes "Описание изменений"

# Создать релиз с автогенерацией notes
gh release create v1.0.0 --generate-notes

# Скачать артефакты релиза
gh release download v1.0.0
```

### Gists

```bash
# Создать gist
gh gist create file.txt

# Создать приватный gist
gh gist create file.txt --private

# Список ваших gists
gh gist list
```

---

## Лучшие практики

### Сообщения коммитов

Хорошие сообщения коммитов помогают понять историю проекта:

```bash
# Плохо
git commit -m "fix"
git commit -m "update"

# Хорошо
git commit -m "Исправил ошибку авторизации при истёкшем токене"
git commit -m "Добавил валидацию email в форме регистрации"
```

**Структура сообщения:**
- Первая строка: краткое описание (до 50 символов)
- Пустая строка
- Подробное описание (опционально)

```bash
git commit -m "Добавил тёмную тему

- Реализовал переключатель в настройках
- Добавил CSS-переменные для цветов
- Сохранение предпочтения в localStorage

Closes #12"
```

### Стратегии ветвления

**Простая стратегия для небольших проектов:**

```
main (основная ветка)
  └── feature/название-функции
  └── fix/название-бага
```

**Git Flow для больших проектов:**

```
main (продакшен)
  └── develop (разработка)
        └── feature/название
        └── release/v1.0
        └── hotfix/критический-баг
```

### Связывание PR с Issues

Используйте ключевые слова в описании PR для автоматического закрытия issues:

```markdown
Closes #42
Fixes #42
Resolves #42
```

При слиянии PR связанный issue автоматически закроется.

---

## Устранение проблем

### Ошибка авторизации

```
error: failed to push some refs to 'github.com:user/repo.git'
```

**Решение:**
```bash
gh auth refresh
```

### Конфликты при merge

```
CONFLICT (content): Merge conflict in file.txt
```

**Решение:**
1. Откройте файл с конфликтом
2. Найдите маркеры `<<<<<<<`, `=======`, `>>>>>>>`
3. Выберите нужный вариант или объедините изменения
4. Удалите маркеры
5. `git add file.txt && git commit`

Или попросите Claude помочь разрешить конфликт.

### MCP сервер не подключается

**Проверьте:**
1. Токен действителен: `gh auth status`
2. Токен в конфигурации правильный
3. Формат JSON корректный (проверьте запятые и кавычки)

**Тест токена:**
```bash
curl -H "Authorization: token ghp_ваш_токен" https://api.github.com/user
```

---

## Чек-лист

- [ ] Git установлен и настроен (name, email)
- [ ] GitHub CLI установлен
- [ ] GitHub CLI авторизован (`gh auth status`)
- [ ] Создан Personal Access Token для MCP
- [ ] MCP сервер github настроен в settings.json
- [ ] Claude видит MCP сервер (`/mcp`)
- [ ] Тестовый запрос к GitHub работает через Claude

---

## Следующие шаги

- [Инструкция 03: Интеграция с Firebase](03-firebase-integration.md)
- [Инструкция 04: Продвинутые MCP серверы](04-advanced-mcp.md)
- [Инструкция 05: Настройка WSL для Windows](05-wsl-setup.md) *(опционально, только для Windows)*

---

*Последнее обновление: январь 2025*
