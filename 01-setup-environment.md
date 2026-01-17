# Установка и настройка среды для AI-разработки

## Введение

### Что такое AI-assisted development

AI-assisted development — это подход к разработке программного обеспечения, при котором искусственный интеллект помогает программисту на всех этапах работы:

- **Написание кода** — AI генерирует код по описанию задачи на естественном языке
- **Отладка** — помогает находить и исправлять ошибки
- **Рефакторинг** — улучшает структуру существующего кода
- **Документация** — автоматически создаёт комментарии и документацию
- **Интеграция** — взаимодействует с внешними сервисами (GitHub, Firebase, Figma и др.)

### Инструменты, которые мы настроим

| Инструмент | Назначение |
|------------|------------|
| **VS Code** | Редактор кода — основная рабочая среда |
| **Claude for VS Code** | Расширение для работы с Claude прямо в редакторе |
| **Codex (OpenAI)** | Альтернативный AI-ассистент от OpenAI |
| **Claude Code CLI** | Командная строка Claude — мощный агент для сложных задач |
| **Codex CLI** | Командная строка Codex |
| **MCP серверы** | Позволяют AI-агентам работать с внешними системами |

### Что получим в результате

После выполнения этой инструкции у вас будет полностью настроенная среда разработки, в которой AI-агенты смогут:

- Писать и редактировать код в ваших проектах
- Работать с Git и GitHub (создавать коммиты, PR, issues)
- Взаимодействовать с Firebase (база данных, хостинг, авторизация)
- Запоминать контекст между сессиями
- Выполнять команды в терминале

---

## Предварительные требования

### Windows: установка winget (опционально)

> **Для пользователей Windows:** Если вы хотите устанавливать программы из командной строки (как показано в примерах с `winget`), вам понадобится **Windows Package Manager (winget)**. Это опционально — все программы можно установить вручную через скачивание установщиков.

**winget** — официальный менеджер пакетов от Microsoft для Windows 10/11, который позволяет устанавливать программы одной командой из PowerShell.

#### Проверка наличия winget

```powershell
winget --version
```

Если команда возвращает версию (например, `v1.6.3482`), winget уже установлен.

#### Установка winget

<details>
<summary><strong>Способ 1: Через Microsoft Store (рекомендуется)</strong></summary>

1. Откройте **Microsoft Store**
2. Найдите **"App Installer"** (или "Установщик приложений")
3. Нажмите "Обновить" или "Получить"
4. Перезапустите PowerShell после установки

</details>

<details>
<summary><strong>Способ 2: Прямая загрузка</strong></summary>

Если Microsoft Store недоступен, выполните в PowerShell от имени администратора:

```powershell
$progressPreference = 'silentlyContinue'
Write-Host "Скачивание App Installer..." -ForegroundColor Cyan
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
Write-Host "Установка..." -ForegroundColor Cyan
Add-AppxPackage -Path "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
Write-Host "Готово! Перезапустите PowerShell" -ForegroundColor Green
```

</details>

**Без winget:** Если вы не хотите устанавливать winget, просто скачивайте установщики с официальных сайтов программ (ссылки приведены в каждом разделе).

---

### Node.js (v18 или выше)

Node.js — это среда выполнения JavaScript. Она необходима для:
- Установки Claude Code CLI и Codex CLI (они распространяются через npm)
- Запуска MCP серверов

> **Примечание:** Если вы планируете использовать только Claude Desktop (не CLI), Node.js можно не устанавливать — в Claude Desktop есть встроенный Node.js для MCP серверов. Однако для полноценной работы с CLI-инструментами установка обязательна.

#### Проверка установки

Откройте терминал и выполните:

```bash
node --version
npm --version
```

Если команды возвращают версии (например, `v20.10.0` и `10.2.3`), Node.js уже установлен.

#### Установка Node.js

<details>
<summary><strong>Windows</strong></summary>

1. Перейдите на [nodejs.org](https://nodejs.org/)
2. Скачайте LTS-версию (рекомендуется)
3. Запустите установщик и следуйте инструкциям
4. Перезапустите терминал после установки

Альтернативно через winget:
```powershell
winget install OpenJS.NodeJS.LTS
```

</details>

<details>
<summary><strong>macOS</strong></summary>

Через Homebrew (рекомендуется):
```bash
brew install node@20
```

Или скачайте установщик с [nodejs.org](https://nodejs.org/)

</details>

<details>
<summary><strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

</details>

### Git

Git — система контроля версий. Необходима для работы с репозиториями.

#### Проверка установки

```bash
git --version
```

#### Установка Git

<details>
<summary><strong>Windows</strong></summary>

1. Скачайте установщик с [git-scm.com](https://git-scm.com/download/win)
2. Запустите и следуйте инструкциям (рекомендуемые настройки по умолчанию подходят)

Или через winget:
```powershell
winget install Git.Git
```

</details>

<details>
<summary><strong>macOS</strong></summary>

Git обычно предустановлен. Если нет:
```bash
brew install git
```

</details>

<details>
<summary><strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
sudo apt-get update
sudo apt-get install git
```

</details>

#### Базовая настройка Git

После установки настройте имя и email:

```bash
git config --global user.name "Ваше Имя"
git config --global user.email "your.email@example.com"
```

---

## Установка VS Code

Visual Studio Code — бесплатный редактор кода от Microsoft. Он станет основной средой для разработки с AI.

### Загрузка и установка

<details>
<summary><strong>Windows</strong></summary>

1. Перейдите на [code.visualstudio.com](https://code.visualstudio.com/)
2. Скачайте установщик для Windows
3. Запустите и установите, отметив опции:
   - ✅ Add "Open with Code" action to Windows Explorer file context menu
   - ✅ Add "Open with Code" action to Windows Explorer directory context menu
   - ✅ Add to PATH

Или через winget:
```powershell
winget install Microsoft.VisualStudioCode
```

</details>

<details>
<summary><strong>macOS</strong></summary>

Через Homebrew:
```bash
brew install --cask visual-studio-code
```

Или скачайте с [code.visualstudio.com](https://code.visualstudio.com/)

</details>

<details>
<summary><strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

</details>

### Базовая настройка VS Code

Откройте VS Code и настройте базовые параметры через `File → Preferences → Settings` (или `Cmd+,` на macOS):

| Настройка | Рекомендуемое значение | Зачем |
|-----------|----------------------|-------|
| Auto Save | `afterDelay` | Автосохранение файлов |
| Format On Save | `true` | Автоформатирование при сохранении |
| Word Wrap | `on` | Перенос длинных строк |

---

## Установка расширений VS Code

### Claude for VS Code

Официальное расширение от Anthropic для работы с Claude.

1. Откройте VS Code
2. Перейдите в Extensions (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Найдите "Claude" (издатель: Anthropic)
4. Нажмите Install

Или установите через командную строку:
```bash
code --install-extension anthropic.claude-code
```

### Codex (OpenAI)

Расширение для работы с моделями OpenAI.

1. В Extensions найдите "Codex" (издатель: OpenAI)
2. Нажмите Install

Или:
```bash
code --install-extension openai.codex
```

### Рекомендуемые дополнительные расширения

| Расширение | Назначение |
|------------|------------|
| **GitLens** | Расширенная работа с Git: blame, history, сравнение |
| **Error Lens** | Показывает ошибки прямо в коде |
| **Prettier** | Форматирование кода |
| **ESLint** | Линтер для JavaScript/TypeScript |

Установка одной командой:
```bash
code --install-extension eamodio.gitlens
code --install-extension usernamehw.errorlens
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
```

---

## Установка CLI-инструментов

### Claude Code CLI

Claude Code — это мощный AI-агент, работающий в командной строке. Он может выполнять сложные многошаговые задачи, редактировать файлы, запускать команды.

```bash
npm install -g @anthropic-ai/claude-code
```

Проверка установки:
```bash
claude --version
```

### Codex CLI

```bash
npm install -g @openai/codex
```

Проверка:
```bash
codex --version
```

---

## Настройка API-ключей

Для работы AI-инструментов необходимы API-ключи.

### Получение ключа Anthropic (для Claude)

1. Перейдите на [console.anthropic.com](https://console.anthropic.com/)
2. Зарегистрируйтесь или войдите
3. Перейдите в раздел API Keys
4. Создайте новый ключ и скопируйте его

> **Важно:** Ключ показывается только один раз. Сохраните его в безопасном месте.

Документация по биллингу: [docs.anthropic.com/claude/docs/billing](https://docs.anthropic.com/en/docs/build-with-claude/billing)

### Получение ключа OpenAI (для Codex)

1. Перейдите на [platform.openai.com](https://platform.openai.com/)
2. Зарегистрируйтесь или войдите
3. Перейдите в API Keys
4. Создайте новый ключ

### Настройка переменных окружения

<details>
<summary><strong>Windows (PowerShell)</strong></summary>

Временно (только для текущей сессии):
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-..."
$env:OPENAI_API_KEY = "sk-..."
```

Постоянно (через системные переменные):
1. Нажмите `Win + R`, введите `sysdm.cpl`
2. Вкладка "Дополнительно" → "Переменные среды"
3. В разделе "Переменные среды пользователя" нажмите "Создать"
4. Добавьте `ANTHROPIC_API_KEY` и `OPENAI_API_KEY`

Или через PowerShell:
```powershell
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-...", "User")
[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-...", "User")
```

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

Добавьте в `~/.bashrc`, `~/.zshrc` или `~/.profile`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
```

Затем перезагрузите конфигурацию:
```bash
source ~/.bashrc  # или ~/.zshrc
```

</details>

### Проверка

```bash
echo $ANTHROPIC_API_KEY  # macOS/Linux
echo $env:ANTHROPIC_API_KEY  # Windows PowerShell
```

---

## Установка внешних CLI

Эти инструменты позволяют AI-агентам взаимодействовать с внешними сервисами.

### GitHub CLI

GitHub CLI (`gh`) — официальный инструмент для работы с GitHub из командной строки.

<details>
<summary><strong>Windows</strong></summary>

```powershell
winget install GitHub.cli
```

</details>

<details>
<summary><strong>macOS</strong></summary>

```bash
brew install gh
```

</details>

<details>
<summary><strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

</details>

#### Авторизация в GitHub

```bash
gh auth login
```

Следуйте интерактивным инструкциям. Рекомендуется авторизация через браузер.

### Firebase CLI

Firebase CLI позволяет управлять проектами Firebase.

```bash
npm install -g firebase-tools
```

#### Авторизация в Firebase

```bash
firebase login
```

Откроется браузер для авторизации через Google-аккаунт.

---

## Настройка MCP серверов

### Что такое MCP

**MCP (Model Context Protocol)** — это протокол, позволяющий AI-моделям взаимодействовать с внешними инструментами и сервисами. MCP серверы — это "мосты", которые дают AI-агентам возможности:

- Читать и записывать файлы
- Делать HTTP-запросы
- Работать с базами данных
- Взаимодействовать с API (GitHub, Firebase, Telegram и др.)

### Базовые MCP серверы

Мы настроим три основных сервера:

| Сервер | Назначение |
|--------|------------|
| **filesystem** | Работа с файлами вне рабочей директории |
| **github** | Полная работа с GitHub: repos, issues, PR, actions |
| **memory** | Персистентная память между сессиями |

### Установка MCP серверов

```bash
npm install -g @anthropic-ai/mcp-server-filesystem
npm install -g @anthropic-ai/mcp-server-github
npm install -g @anthropic-ai/mcp-server-memory
```

### Конфигурация для Claude Code CLI

Создайте или отредактируйте файл конфигурации:

<details>
<summary><strong>Windows</strong></summary>

Путь: `%APPDATA%\claude\settings.json`

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "C:\\Users\\ВашеИмя\\Projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_..."
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-memory"]
    }
  }
}
```

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

Путь: `~/.config/claude/settings.json`

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
        "GITHUB_TOKEN": "ghp_..."
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-memory"]
    }
  }
}
```

</details>

### Получение GitHub Token для MCP

1. Перейдите на [github.com/settings/tokens](https://github.com/settings/tokens)
2. Generate new token (classic)
3. Выберите scopes: `repo`, `read:org`, `read:user`
4. Скопируйте токен и добавьте в конфигурацию

### Конфигурация для Claude Desktop

Если вы используете Claude Desktop, конфигурация находится в другом месте:

<details>
<summary><strong>Windows</strong></summary>

Путь: `%APPDATA%\Claude\claude_desktop_config.json`

</details>

<details>
<summary><strong>macOS</strong></summary>

Путь: `~/Library/Application Support/Claude/claude_desktop_config.json`

</details>

Формат файла аналогичен примерам выше.

### Проверка работоспособности

Запустите Claude Code и проверьте доступность MCP серверов:

```bash
claude
```

В интерактивном режиме введите:
```
/mcp
```

Вы должны увидеть список подключенных серверов.

### Расширенные MCP серверы

Для специфических задач доступны дополнительные серверы:

| Сервер | Назначение | Установка |
|--------|------------|-----------|
| **fetch** | HTTP-запросы к API | `npm i -g @anthropic-ai/mcp-server-fetch` |
| **puppeteer** | Браузерная автоматизация | `npm i -g @anthropic-ai/mcp-server-puppeteer` |
| **postgres** | Работа с PostgreSQL | `npm i -g @anthropic-ai/mcp-server-postgres` |
| **sqlite** | Работа с SQLite | `npm i -g @anthropic-ai/mcp-server-sqlite` |
| **brave-search** | Веб-поиск | `npm i -g @anthropic-ai/mcp-server-brave-search` |
| **telegram** | Интеграция с Telegram | `pip install telegram-mcp` |

Полный список: [github.com/anthropics/mcp-servers](https://github.com/anthropics/mcp-servers)

---

## Проверка установки

### Тестовые команды

Выполните каждую команду и убедитесь, что она работает:

```bash
# Node.js и npm
node --version
npm --version

# Git
git --version

# VS Code
code --version

# Claude Code CLI
claude --version

# Codex CLI
codex --version

# GitHub CLI
gh --version
gh auth status

# Firebase CLI
firebase --version
firebase projects:list
```

### Чек-лист готовности

- [ ] Node.js v18+ установлен
- [ ] Git установлен и настроен (name, email)
- [ ] VS Code установлен
- [ ] Расширение Claude for VS Code установлено
- [ ] Расширение Codex установлено
- [ ] Claude Code CLI установлен
- [ ] Codex CLI установлен
- [ ] API-ключ Anthropic настроен
- [ ] API-ключ OpenAI настроен
- [ ] GitHub CLI установлен и авторизован
- [ ] Firebase CLI установлен и авторизован
- [ ] MCP серверы настроены
- [ ] Команда `/mcp` в Claude Code показывает серверы

---

## Дополнительно

### Настройка директории `.claude/`

Claude Code поддерживает проектные настройки через директорию `.claude/` в корне проекта.

#### Структура

```
your-project/
├── .claude/
│   ├── CLAUDE.md          # Инструкции для агента
│   ├── settings.json      # Настройки проекта
│   └── commands/          # Кастомные команды
│       └── review.md
├── src/
└── ...
```

#### CLAUDE.md — инструкции для агента(с примером)

Создайте файл `.claude/CLAUDE.md` в корне проекта:

```markdown
# Инструкции для Claude

## О проекте
Это веб-приложение на React + TypeScript с бэкендом на Firebase.

## Стек технологий
- Frontend: React 18, TypeScript, Tailwind CSS
- Backend: Firebase (Firestore, Auth, Functions)
- Тестирование: Vitest, Testing Library

## Правила кодирования
- Используй функциональные компоненты с хуками
- Типизируй все props и состояния
- Пиши комментарии на русском языке
- Следуй структуре папок: components/, hooks/, utils/, types/

## Команды
- `npm run dev` — запуск dev-сервера
- `npm run build` — сборка
- `npm run test` — тесты
```

Claude будет автоматически читать этот файл при работе с проектом и следовать указанным инструкциям.

#### Кастомные команды

Создайте файл `.claude/commands/review.md`:

```markdown
Проведи code review последнего коммита:
1. Проверь на потенциальные баги
2. Оцени читаемость кода
3. Проверь соответствие код-стайлу проекта
4. Предложи улучшения
```

Теперь в Claude Code можно использовать команду:
```
/project:review
```

### Глобальные инструкции

Для настроек, применяемых ко всем проектам, создайте файл:

<details>
<summary><strong>Windows</strong></summary>

`%USERPROFILE%\.claude\CLAUDE.md`

</details>

<details>
<summary><strong>macOS / Linux</strong></summary>

`~/.claude/CLAUDE.md`

</details>

---

## Следующие шаги

После настройки среды рекомендуем ознакомиться с:

- [Инструкция 02: Работа с GitHub через AI-агентов](02-github-ai-agents.md)
- [Инструкция 03: Интеграция с Firebase](03-firebase-integration.md)
- [Инструкция 04: Продвинутые MCP серверы](04-advanced-mcp.md)
- [Инструкция 05: Настройка WSL для Windows](05-wsl-setup.md) *(опционально, только для Windows)*

---

*Последнее обновление: январь 2025*
