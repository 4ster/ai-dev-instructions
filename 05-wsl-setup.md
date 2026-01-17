# Настройка WSL для Windows

## Введение

### Что такое WSL

**WSL (Windows Subsystem for Linux)** — это технология Microsoft, позволяющая запускать Linux прямо внутри Windows без виртуальных машин или двойной загрузки.

С WSL вы получаете:
- Полноценный Linux-терминал (bash, zsh)
- Нативные Linux-инструменты (grep, sed, awk, ssh)
- Менеджеры пакетов (apt, yum)
- Возможность запускать Linux-приложения

### Зачем WSL для AI-разработки

Многие инструменты разработки изначально создавались для Unix-систем. WSL решает проблемы:

| Проблема в Windows | Решение с WSL |
|-------------------|---------------|
| Скрипты с `#!/bin/bash` не работают | Нативное выполнение bash-скриптов |
| Пути с обратными слэшами `\` | Unix-пути с `/` |
| Проблемы с правами доступа (chmod) | Полная поддержка Unix-прав |
| Некоторые npm-пакеты не работают | Нативная Linux-среда |
| Docker требует Hyper-V или WSL2 | Docker Desktop интегрируется с WSL2 |

### WSL1 vs WSL2

| Характеристика | WSL1 | WSL2 |
|----------------|------|------|
| Архитектура | Трансляция syscall | Полное ядро Linux |
| Производительность файловой системы Linux | Медленнее | Быстрее |
| Производительность файловой системы Windows | Быстрее | Медленнее |
| Совместимость | Частичная | Полная |
| Docker | Ограниченная | Полная поддержка |

**Рекомендация:** Используйте **WSL2** — это современная версия с полной совместимостью.

---

## Требования

### Системные требования

- **Windows 10** версии 2004 (сборка 19041) или выше
- **Windows 11** — любая версия
- Включённая виртуализация в BIOS/UEFI

### Проверка версии Windows

Нажмите `Win + R`, введите `winver` и нажмите Enter.

Вы увидите окно с версией Windows. Убедитесь, что:
- Windows 10: версия 2004 или выше
- Windows 11: любая версия подходит

### Проверка виртуализации

Откройте **Диспетчер задач** (`Ctrl + Shift + Esc`) → вкладка **Производительность** → **ЦП**.

В правом нижнем углу должно быть: **Виртуализация: Включено**

Если виртуализация выключена:
1. Перезагрузите компьютер и войдите в BIOS/UEFI (обычно `F2`, `F10`, `Del` при загрузке)
2. Найдите настройку **Intel VT-x** или **AMD-V** (названия отличаются у разных производителей)
3. Включите её и сохраните изменения

---

## Установка WSL

### Способ 1: Автоматическая установка (рекомендуется)

Откройте **PowerShell от имени администратора**:
1. Нажмите `Win + X`
2. Выберите "Терминал Windows (Администратор)" или "PowerShell (Администратор)"

Выполните команду:

```powershell
wsl --install
```

Эта команда автоматически:
- Включит необходимые компоненты Windows
- Установит WSL2
- Установит Ubuntu как дистрибутив по умолчанию

**После установки перезагрузите компьютер.**

### Способ 2: Ручная установка

Если автоматическая установка не работает:

#### Шаг 1: Включение компонентов Windows

```powershell
# Включить WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Включить платформу виртуальных машин
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Перезагрузите компьютер.**

#### Шаг 2: Установка ядра WSL2

Скачайте и установите пакет обновления ядра WSL2:
[aka.ms/wsl2kernel](https://aka.ms/wsl2kernel)

#### Шаг 3: Установка WSL2 по умолчанию

```powershell
wsl --set-default-version 2
```

#### Шаг 4: Установка дистрибутива

```powershell
wsl --install -d Ubuntu
```

### Проверка установки

```powershell
wsl --version
```

Вы должны увидеть версию WSL и ядра Linux.

```powershell
wsl --list --verbose
```

Покажет установленные дистрибутивы и их версии (1 или 2).

---

## Выбор и установка дистрибутива

### Доступные дистрибутивы

Посмотреть список доступных дистрибутивов:

```powershell
wsl --list --online
```

| Дистрибутив | Описание | Рекомендация |
|-------------|----------|--------------|
| **Ubuntu** | Самый популярный, большое сообщество | ✅ Рекомендуется для начинающих |
| **Ubuntu-22.04** | LTS-версия с долгой поддержкой | ✅ Для стабильной работы |
| **Debian** | Стабильный, минималистичный | Для опытных пользователей |
| **openSUSE** | Enterprise-ориентированный | Специфические задачи |
| **Kali Linux** | Для тестирования безопасности | Специализированный |

### Установка дистрибутива

```powershell
# Ubuntu (последняя версия)
wsl --install -d Ubuntu

# Или конкретная версия
wsl --install -d Ubuntu-22.04
```

### Первый запуск

После установки откройте Ubuntu из меню "Пуск" или введите в терминале:

```powershell
wsl
```

При первом запуске система попросит создать пользователя:

```
Enter new UNIX username: ваше_имя
New password: ********
Retype new password: ********
```

> **Важно:** Этот пароль будет использоваться для команд `sudo`. Запомните его!

### Управление дистрибутивами

```powershell
# Список установленных
wsl --list --verbose

# Установить дистрибутив по умолчанию
wsl --set-default Ubuntu

# Удалить дистрибутив
wsl --unregister Ubuntu

# Остановить WSL
wsl --shutdown

# Запустить конкретный дистрибутив
wsl -d Ubuntu
```

---

## Базовая настройка Linux

### Обновление системы

Первое, что нужно сделать после установки:

```bash
sudo apt update && sudo apt upgrade -y
```

### Установка базовых инструментов

```bash
sudo apt install -y curl wget git build-essential
```

| Пакет | Назначение |
|-------|------------|
| `curl`, `wget` | Загрузка файлов из интернета |
| `git` | Система контроля версий |
| `build-essential` | Компиляторы и инструменты сборки (gcc, make) |

### Настройка Git

```bash
git config --global user.name "Ваше Имя"
git config --global user.email "your.email@example.com"
```

### Настройка shell (опционально)

По умолчанию используется bash. Многие предпочитают zsh с Oh My Zsh:

```bash
# Установка zsh
sudo apt install -y zsh

# Установка Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Файл .wslconfig (настройка ресурсов)

Создайте файл `C:\Users\ВашеИмя\.wslconfig` в Windows:

```ini
[wsl2]
memory=8GB          # Ограничение RAM (по умолчанию 50% от системной)
processors=4        # Количество процессоров
swap=2GB           # Размер swap-файла

[experimental]
autoMemoryReclaim=gradual  # Автоматическое освобождение памяти
```

После изменения перезапустите WSL:

```powershell
wsl --shutdown
```

---

## Интеграция с VS Code

VS Code имеет отличную интеграцию с WSL через расширение Remote - WSL.

### Установка расширения

1. Откройте VS Code в Windows
2. Установите расширение **"WSL"** (или "Remote - WSL") от Microsoft

Или через командную строку:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

### Открытие проекта в WSL

#### Способ 1: Из VS Code

1. Нажмите `F1` (или `Ctrl+Shift+P`)
2. Введите "WSL: Connect to WSL"
3. VS Code переподключится к WSL
4. Откройте папку: `File → Open Folder`

#### Способ 2: Из терминала WSL

```bash
# Перейдите в папку проекта
cd ~/projects/my-app

# Откройте VS Code
code .
```

VS Code автоматически откроется в режиме WSL.

### Индикатор WSL

Когда VS Code подключён к WSL, в левом нижнем углу отображается:

```
WSL: Ubuntu
```

### Терминал в VS Code

Когда VS Code работает в режиме WSL, встроенный терминал (`Ctrl+``) автоматически открывается в Linux-среде.

### Расширения в WSL

Некоторые расширения VS Code нужно устанавливать отдельно для WSL:
1. Откройте боковую панель Extensions
2. Расширения с пометкой "Install in WSL" установите повторно

---

## Настройка инструментов разработки в WSL

### Node.js через nvm

**nvm** (Node Version Manager) — рекомендуемый способ установки Node.js в Linux.

```bash
# Установка nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Перезапустите терминал или выполните:
source ~/.bashrc

# Установка последней LTS-версии Node.js
nvm install --lts

# Проверка
node --version
npm --version
```

### Преимущества nvm

- Легко переключаться между версиями Node.js
- Не требует `sudo` для глобальных пакетов
- Изолированные среды для разных проектов

```bash
# Установить конкретную версию
nvm install 20

# Переключиться на версию
nvm use 20

# Список установленных версий
nvm list
```

### Python

```bash
# Python обычно предустановлен, проверьте:
python3 --version

# Установка pip
sudo apt install -y python3-pip

# Установка venv для виртуальных окружений
sudo apt install -y python3-venv
```

### Docker

Docker Desktop для Windows интегрируется с WSL2.

1. Скачайте и установите [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. В настройках Docker Desktop:
   - Settings → Resources → WSL Integration
   - Включите интеграцию с вашим дистрибутивом

Проверка в WSL:

```bash
docker --version
docker run hello-world
```

---

## Claude Code CLI в WSL

### Установка

В терминале WSL:

```bash
# Убедитесь, что Node.js установлен
node --version

# Установка Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Проверка
claude --version
```

### Настройка API-ключа

```bash
# Добавьте в ~/.bashrc или ~/.zshrc
export ANTHROPIC_API_KEY="sk-ant-..."

# Применить изменения
source ~/.bashrc
```

### Настройка MCP серверов

Создайте файл конфигурации:

```bash
mkdir -p ~/.config/claude
nano ~/.config/claude/settings.json
```

Содержимое:

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

### Проверка

```bash
claude
# В интерактивном режиме:
/mcp
```

---

## Работа с файлами между Windows и WSL

### Доступ к файлам Windows из WSL

Диски Windows монтируются в `/mnt/`:

```bash
# Диск C:
cd /mnt/c/

# Папка пользователя
cd /mnt/c/Users/ВашеИмя/

# Пример: открыть проект с диска D:
cd /mnt/d/Projects/my-app
```

### Доступ к файлам WSL из Windows

Файловая система WSL доступна через путь:

```
\\wsl$\Ubuntu\home\username\
```

Или в проводнике введите в адресную строку:

```
\\wsl$
```

### Рекомендации по хранению файлов

| Сценарий | Где хранить | Почему |
|----------|-------------|--------|
| Проекты, с которыми работаете в WSL | `~/projects/` в WSL | Максимальная производительность |
| Файлы, нужные в обеих системах | `/mnt/c/...` | Доступны везде |
| Git-репозитории для Linux-разработки | `~/` в WSL | Корректная работа chmod, symlinks |

> **Важно:** Работа с файлами на `/mnt/c/` из WSL медленнее, чем с файлами в домашней директории WSL.

### Создание символической ссылки

Для удобства можно создать ссылку на папку Windows:

```bash
ln -s /mnt/d/Projects ~/projects-windows
```

Теперь `~/projects-windows` будет вести на `D:\Projects`.

---

## Полезные команды WSL

### Управление из Windows (PowerShell)

```powershell
# Статус WSL
wsl --status

# Список дистрибутивов
wsl --list --verbose

# Остановить все
wsl --shutdown

# Остановить конкретный
wsl --terminate Ubuntu

# Запустить дистрибутив
wsl -d Ubuntu

# Запустить команду в WSL из Windows
wsl ls -la

# Экспорт дистрибутива (бэкап)
wsl --export Ubuntu D:\Backups\ubuntu-backup.tar

# Импорт дистрибутива
wsl --import Ubuntu-restored D:\WSL\Ubuntu D:\Backups\ubuntu-backup.tar
```

### Работа внутри WSL

```bash
# Информация о системе
uname -a
lsb_release -a

# Использование диска
df -h

# Использование памяти
free -h

# Запущенные процессы
htop  # или top

# Открыть файл в Windows-приложении
explorer.exe .          # Открыть текущую папку в проводнике
notepad.exe file.txt    # Открыть файл в блокноте
code .                  # Открыть в VS Code
```

### Выполнение Windows-команд из WSL

```bash
# Запустить Windows-программу
/mnt/c/Windows/System32/notepad.exe

# Или добавить .exe к имени
notepad.exe
explorer.exe
cmd.exe /c "dir"
```

---

## Troubleshooting

### WSL не устанавливается

**Ошибка:** "WSL 2 requires an update to its kernel component"

**Решение:**
1. Скачайте обновление ядра: [aka.ms/wsl2kernel](https://aka.ms/wsl2kernel)
2. Установите и перезагрузите

### Виртуализация не включена

**Ошибка:** "Please enable the Virtual Machine Platform Windows feature"

**Решение:**
1. Откройте PowerShell от администратора
2. Выполните:
   ```powershell
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```
3. Перезагрузите компьютер
4. Если не помогло — включите виртуализацию в BIOS

### WSL использует слишком много памяти

**Решение:** Создайте файл `.wslconfig` (см. раздел "Базовая настройка Linux").

### Медленная работа с файлами

**Причина:** Работа с файлами на `/mnt/c/` медленная в WSL2.

**Решение:** Храните проекты в домашней директории WSL (`~/projects/`).

### Git показывает все файлы как изменённые

**Причина:** Разница в окончаниях строк (CRLF в Windows, LF в Linux).

**Решение:**

```bash
# В WSL
git config --global core.autocrlf input

# Для конкретного репозитория создайте .gitattributes:
* text=auto eol=lf
```

### Не работает копирование/вставка в терминале

**Решение для Windows Terminal:**
- `Ctrl+Shift+C` — копировать
- `Ctrl+Shift+V` — вставить

Или включите в настройках: Settings → Actions → убедитесь, что copy/paste привязаны.

### Claude Code CLI не находит API-ключ

**Проверьте:**

```bash
echo $ANTHROPIC_API_KEY
```

Если пусто:
1. Добавьте в `~/.bashrc`:
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-..."
   ```
2. Выполните `source ~/.bashrc`
3. Перезапустите терминал

### Ошибка "command not found" после установки npm-пакета

**Причина:** npm глобальные пакеты не в PATH.

**Решение с nvm:** Используйте nvm — он автоматически настраивает PATH.

Или добавьте в `~/.bashrc`:

```bash
export PATH="$PATH:$(npm config get prefix)/bin"
```

---

## Чек-лист готовности

- [ ] WSL2 установлен (`wsl --version`)
- [ ] Ubuntu (или другой дистрибутив) установлен
- [ ] Система обновлена (`sudo apt update && sudo apt upgrade`)
- [ ] Git установлен и настроен
- [ ] Node.js установлен через nvm
- [ ] VS Code с расширением WSL работает
- [ ] Claude Code CLI установлен в WSL
- [ ] API-ключ настроен в переменных окружения
- [ ] Понимаете, как работать с файлами между Windows и WSL

---

## Следующие шаги

После настройки WSL вы можете:
- Использовать Linux-инструменты для разработки
- Запускать Docker-контейнеры
- Работать с проектами, требующими Unix-среды
- Использовать Claude Code CLI в Linux-окружении

Рекомендуем ознакомиться с:
- [Инструкция 02: Работа с GitHub через AI-агентов](02-github-ai-agents.md)
- [Инструкция 03: Интеграция с Firebase](03-firebase-integration.md)
- [Инструкция 04: Продвинутые MCP серверы](04-advanced-mcp.md)

---

*Последнее обновление: январь 2025*
