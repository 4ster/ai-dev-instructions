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
- Выполнять команды в терминале

---


## Предварительные требования

> **⚠️ Важно: Права администратора**
>
> - **Установка программ** (через `winget` или установщики) — требует прав администратора
> - **Глобальная установка npm пакетов** (`npm install -g`) — требует прав администратора на Windows
> - **Использование программ** (`code`, `gh`, `firebase`, `claude`, `codex` и др.) — запускайте от обычного пользователя (НЕ от администратора)
>
> **Для Windows:** Запускайте PowerShell от имени администратора только для установки программ и глобальных npm пакетов. Все остальные команды выполняйте в обычном терминале.

---
## Windows
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

**Без winget:** Если вы не хотите устанавливать winget, просто скачивайте установщики с официальных сайтов программ.


<details>
<summary><strong>Установка остальных инструментов Windows</strong></summary>

```powershell
# Node.js и npm
node --version
npm --version
winget install OpenJS.NodeJS.LTS

# Git
git --version
winget install Git.Git
git config --global user.name "Ваше Имя"
git config --global user.email "your.email@example.com"

# Visual Studio Code
code --version
winget install Microsoft.VisualStudioCode

# Устанавливаем расширения Claude и Codex в vscode
code --install-extension anthropic.claude-code
code --install-extension openai.codex

# Claude Desktop and terminal
claude --version
winget install Anthropic.Claude

# Codex Desktop and terminal
codex --version
#brew install --cask chatgpt
npm i -g @openai/codex

# Github CLI
gh --version
gh auth status
winget install GitHub.cli
gh auth login

# Firebase CLI
firebase --version
firebase projects:list
npm i -g firebase-tools
firebase login

# MCP Servers
npm i -g @anthropic-ai/mcp-server-filesystem
npm i -g @anthropic-ai/mcp-server-github

```

</details>

---

## Установка на Mac
<details>
<summary><strong>Установка на Mac в командной строке</strong></summary>

```bash
# Node.js и npm
node --version
npm --version
brew install node@24
echo 'export PATH="/opt/homebrew/opt/node@24/bin:$PATH"' >> ~/.zshrc

# Git
git --version
brew install git
git config --global user.name "Ваше Имя"
git config --global user.email "your.email@example.com"

# Visual Studio Code
code --version
# Если vscode установлен, но команда code не работает, то, можно создать символическую ссылку
sudo ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /opt/homebrew/bin/code

# Если vscode не установлен - ставим и создаем символическую ссылку
brew install --cask visual-studio-code
sudo ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /opt/homebrew/bin/code

# Устанавливаем расширения Claude и Codex в vscode
code --install-extension anthropic.claude-code
code --install-extension openai.codex

# Claude Desktop and terminal
claude --version
brew install --cask claude

# Codex Desktop and terminal
codex --version
brew install --cask chatgpt
npm i -g @openai/codex


# Github CLI
gh --version
gh auth status
brew install gh
gh auth login

# Firebase CLI
firebase --version
firebase projects:list
npm i -g firebase-tools
firebase login

# MCP Servers
npm i -g @anthropic-ai/mcp-server-filesystem
npm i -g @anthropic-ai/mcp-server-github
```

</details>

## Установка на Linux
<details>
<summary><strong>Установка на Linux (Ubuntu/Debian) в коммандной строке</strong></summary>


```bash
# Обновляем пакеты
sudo apt update

# Node.js и npm
node --version
npm --version
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt install -y nodejs

# Git
git --version
sudo apt install git
git config --global user.name "Ваше Имя"
git config --global user.email "your.email@example.com"

# Visual Studio Code
code --version
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Устанавливаем расширения Claude и Codex в vscode
code --install-extension anthropic.claude-code
code --install-extension openai.codex

# Codex Desktop and terminal
codex --version
npm i -g @openai/codex

# Github CLI
gh --version
gh auth status
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
gh auth login

# Firebase CLI
firebase --version
firebase projects:list
npm i -g firebase-tools
firebase login

# MCP Servers
npm i -g @anthropic-ai/mcp-server-filesystem
npm i -g @anthropic-ai/mcp-server-github
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

### AI-расширения

#### Claude for VS Code

Официальное расширение от Anthropic для работы с Claude прямо в редакторе.

1. Откройте VS Code
2. Перейдите в Extensions (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Найдите "Claude" (издатель: Anthropic)
4. Нажмите Install

#### Codex for VS Code

**Требования:** Подписка ChatGPT Plus ($20/месяц) или OpenAI API

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

## Настройка MCP серверов

### Что такое MCP

**MCP (Model Context Protocol)** — это протокол, позволяющий AI-моделям взаимодействовать с внешними инструментами и сервисами. MCP серверы — это "мосты", которые дают AI-агентам возможности:

- Читать и записывать файлы
- Делать HTTP-запросы
- Работать с базами данных
- Взаимодействовать с API (GitHub, Firebase, Telegram и др.)

### Базовые MCP серверы

Мы настроим два основных сервера:

| Сервер | Назначение |
|--------|------------|
| **filesystem** | Работа с файлами вне рабочей директории |
| **github** | Полная работа с GitHub: repos, issues, PR, actions |

### Установка MCP серверов

```bash
npm install -g @anthropic-ai/mcp-server-filesystem
npm install -g @anthropic-ai/mcp-server-github
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
    }
  }
}
```

</details>

### Получение GitHub Token для MCP

GitHub токен необходим для работы MCP сервера GitHub. Он позволяет AI-агенту взаимодействовать с вашими репозиториями, issues и pull requests.

#### Пошаговая инструкция

1. **Откройте настройки токенов GitHub**:
   - Перейдите на [github.com/settings/tokens](https://github.com/settings/tokens)
   - Или: GitHub → Settings (справа вверху) → Developer settings → Personal access tokens → Tokens (classic)

2. **Создайте новый токен**:
   - Нажмите **"Generate new token"** → **"Generate new token (classic)"**
   - Дайте токену понятное имя, например: `Claude MCP Server` или `AI Development`

3. **Выберите срок действия**:
   - Рекомендуется: `90 days` или `No expiration` (если доверяете безопасности своей машины)
   - Токены с истекшим сроком нужно будет обновлять

4. **Выберите разрешения (scopes)**:

   Минимальные права для работы MCP сервера:
   - ✅ **`repo`** — полный доступ к приватным и публичным репозиториям
   - ✅ **`read:org`** — чтение информации об организации
   - ✅ **`read:user`** — чтение профиля пользователя

   Дополнительные права (опционально):
   - `workflow` — если нужно управлять GitHub Actions
   - `write:packages` — для работы с GitHub Packages
   - `admin:repo_hook` — для управления webhooks

5. **Создайте токен**:
   - Нажмите **"Generate token"** внизу страницы

6. **Скопируйте токен**:
   - ⚠️ **ВАЖНО**: Токен показывается только один раз!
   - Скопируйте его сразу (начинается с `ghp_`)
   - Сохраните в безопасном месте или сразу добавьте в конфигурацию

#### Добавление токена в конфигурацию

Откройте файл конфигурации Claude Code (см. выше) и вставьте токен в секцию `github.env.GITHUB_TOKEN`:

```json
"github": {
  "command": "npx",
  "args": ["-y", "@anthropic-ai/mcp-server-github"],
  "env": {
    "GITHUB_TOKEN": "ghp_ваш_токен_здесь"
  }
}
```

#### Безопасность

- ❌ **Никогда не коммитьте токен в Git**
- ❌ **Не делитесь токеном с другими**
- ✅ Храните токен в конфигурационном файле локально
- ✅ Используйте токены с минимальными необходимыми правами
- ✅ Регулярно обновляйте токены с истекшим сроком

Если токен случайно утёк:
1. Немедленно удалите его на [github.com/settings/tokens](https://github.com/settings/tokens)
2. Создайте новый токен
3. Обновите конфигурацию

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
