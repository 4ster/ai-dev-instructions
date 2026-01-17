# =============================================================================
# Скрипт автоматической установки среды для AI-разработки на Windows
# =============================================================================
#
# Этот скрипт устанавливает все необходимые инструменты для работы с AI-агентами:
# - Node.js
# - Git
# - VS Code + расширения
# - Claude Code CLI и Codex CLI
# - GitHub CLI и Firebase CLI
# - Базовые MCP серверы
#
# ВАЖНО: Запускайте скрипт от имени администратора!
#
# =============================================================================

# Проверка прав администратора
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ОШИБКА: Скрипт должен быть запущен от имени администратора!" -ForegroundColor Red
    Write-Host "Нажмите правой кнопкой на файл и выберите 'Запустить от имени администратора'" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Установка среды для AI-разработки" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# =============================================================================
# Функция для проверки установки программы
# =============================================================================
function Test-CommandExists {
    param($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {
        if (Get-Command $command) { return $true }
    } catch {
        return $false
    } finally {
        $ErrorActionPreference = $oldPreference
    }
}

# =============================================================================
# Проверка наличия winget
# =============================================================================
Write-Host "Проверка winget (Windows Package Manager)..." -ForegroundColor Yellow
Write-Host ""

if (-not (Test-CommandExists winget)) {
    Write-Host "ВНИМАНИЕ: winget не установлен!" -ForegroundColor Red
    Write-Host ""
    Write-Host "winget необходим для автоматической установки программ." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Выберите действие:" -ForegroundColor Cyan
    Write-Host "  1. Установить winget сейчас (рекомендуется)" -ForegroundColor White
    Write-Host "  2. Продолжить без winget (ручная установка)" -ForegroundColor White
    Write-Host "  3. Выйти из скрипта" -ForegroundColor White
    Write-Host ""

    $choice = Read-Host "Ваш выбор (1/2/3)"

    if ($choice -eq "1") {
        Write-Host "`nУстановка winget..." -ForegroundColor Cyan
        try {
            $progressPreference = 'silentlyContinue'
            Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
            Add-AppxPackage -Path "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
            Write-Host "✓ winget установлен успешно" -ForegroundColor Green
            Write-Host "Перезапустите скрипт для продолжения установки" -ForegroundColor Yellow
            pause
            exit 0
        } catch {
            Write-Host "✗ Ошибка установки winget: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "Альтернативный способ:" -ForegroundColor Yellow
            Write-Host "1. Откройте Microsoft Store" -ForegroundColor White
            Write-Host "2. Найдите 'App Installer'" -ForegroundColor White
            Write-Host "3. Нажмите 'Обновить' или 'Получить'" -ForegroundColor White
            Write-Host "4. Перезапустите этот скрипт" -ForegroundColor White
            pause
            exit 1
        }
    } elseif ($choice -eq "2") {
        Write-Host "`nПродолжаем без winget..." -ForegroundColor Yellow
        Write-Host "Программы нужно будет установить вручную:" -ForegroundColor Yellow
        Write-Host "  • Node.js: https://nodejs.org/" -ForegroundColor White
        Write-Host "  • Git: https://git-scm.com/" -ForegroundColor White
        Write-Host "  • VS Code: https://code.visualstudio.com/" -ForegroundColor White
        Write-Host "  • GitHub CLI: https://cli.github.com/" -ForegroundColor White
        Write-Host ""
        Write-Host "Скрипт установит только npm-пакеты (требуется Node.js)" -ForegroundColor Yellow
        Write-Host ""
        $continueWithoutWinget = Read-Host "Продолжить? (y/n)"
        if ($continueWithoutWinget -ne "y") {
            exit 0
        }
    } else {
        Write-Host "Выход из скрипта" -ForegroundColor Gray
        exit 0
    }
    Write-Host ""
} else {
    $wingetVersion = winget --version
    Write-Host "✓ winget установлен: $wingetVersion" -ForegroundColor Green
    Write-Host ""
}

# =============================================================================
# 1. Установка Desktop-приложений для AI
# =============================================================================
Write-Host "[1/9] Установка Desktop-приложений для AI..." -ForegroundColor Yellow

# Claude Desktop
Write-Host "  → Установка Claude Desktop..." -ForegroundColor Cyan
if (Test-CommandExists winget) {
    try {
        winget install --id Anthropic.Claude --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
        Write-Host "  ✓ Claude Desktop установлен" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Ошибка установки Claude Desktop" -ForegroundColor Yellow
        Write-Host "    Установите вручную: https://claude.ai/download" -ForegroundColor Gray
    }
} else {
    Write-Host "  ⚠ winget не найден. Установите вручную: https://claude.ai/download" -ForegroundColor Yellow
}

# ChatGPT Desktop
Write-Host "  → Установка ChatGPT Desktop..." -ForegroundColor Cyan
if (Test-CommandExists winget) {
    try {
        winget install --id OpenAI.ChatGPT --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
        Write-Host "  ✓ ChatGPT Desktop установлен" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Ошибка установки ChatGPT Desktop" -ForegroundColor Yellow
        Write-Host "    Установите вручную: https://openai.com/chatgpt/download" -ForegroundColor Gray
    }
} else {
    Write-Host "  ⚠ winget не найден. Установите вручную: https://openai.com/chatgpt/download" -ForegroundColor Yellow
}

# =============================================================================
# 2. Установка Node.js
# =============================================================================
Write-Host "`n[2/9] Проверка Node.js..." -ForegroundColor Yellow

if (Test-CommandExists node) {
    $nodeVersion = node --version
    Write-Host "  ✓ Node.js уже установлен: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "  → Установка Node.js LTS через winget..." -ForegroundColor Cyan
    try {
        winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✓ Node.js успешно установлен" -ForegroundColor Green

        # Обновление PATH для текущей сессии
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Host "  ✗ Ошибка установки Node.js: $_" -ForegroundColor Red
        Write-Host "    Установите вручную с https://nodejs.org/" -ForegroundColor Yellow
    }
}

# =============================================================================
# 3. Установка Git
# =============================================================================
Write-Host "`n[3/9] Проверка Git..." -ForegroundColor Yellow

if (Test-CommandExists git) {
    $gitVersion = git --version
    Write-Host "  ✓ Git уже установлен: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "  → Установка Git через winget..." -ForegroundColor Cyan
    try {
        winget install Git.Git --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✓ Git успешно установлен" -ForegroundColor Green

        # Обновление PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Host "  ✗ Ошибка установки Git: $_" -ForegroundColor Red
        Write-Host "    Установите вручную с https://git-scm.com/" -ForegroundColor Yellow
    }
}

# Настройка Git (если еще не настроен)
$gitUserName = git config --global user.name 2>$null
if (-not $gitUserName) {
    Write-Host "  → Настройка Git..." -ForegroundColor Cyan
    $userName = Read-Host "    Введите ваше имя для Git"
    $userEmail = Read-Host "    Введите ваш email для Git"
    git config --global user.name "$userName"
    git config --global user.email "$userEmail"
    Write-Host "  ✓ Git настроен" -ForegroundColor Green
}

# =============================================================================
# 4. Установка VS Code
# =============================================================================
Write-Host "`n[4/9] Проверка VS Code..." -ForegroundColor Yellow

if (Test-CommandExists code) {
    $codeVersion = code --version | Select-Object -First 1
    Write-Host "  ✓ VS Code уже установлен: $codeVersion" -ForegroundColor Green
} else {
    Write-Host "  → Установка VS Code через winget..." -ForegroundColor Cyan
    try {
        winget install Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✓ VS Code успешно установлен" -ForegroundColor Green

        # Обновление PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Host "  ✗ Ошибка установки VS Code: $_" -ForegroundColor Red
        Write-Host "    Установите вручную с https://code.visualstudio.com/" -ForegroundColor Yellow
    }
}

# =============================================================================
# 5. Установка расширений VS Code
# =============================================================================
Write-Host "`n[5/9] Установка расширений VS Code..." -ForegroundColor Yellow

if (Test-CommandExists code) {
    $extensions = @(
        @{id="anthropic.claude-code"; name="Claude for VS Code"},
        @{id="openai.codex"; name="Codex (OpenAI)"},
        @{id="eamodio.gitlens"; name="GitLens"},
        @{id="usernamehw.errorlens"; name="Error Lens"},
        @{id="esbenp.prettier-vscode"; name="Prettier"},
        @{id="dbaeumer.vscode-eslint"; name="ESLint"}
    )

    foreach ($ext in $extensions) {
        Write-Host "  → Установка $($ext.name)..." -ForegroundColor Cyan
        try {
            code --install-extension $ext.id --force 2>&1 | Out-Null
            Write-Host "    ✓ $($ext.name) установлен" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠ Ошибка установки $($ext.name)" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  ⚠ VS Code не найден, пропускаем установку расширений" -ForegroundColor Yellow
}

# =============================================================================
# 6. Установка Firebase CLI (опционально)
# =============================================================================
Write-Host "`n[6/9] Установка Firebase CLI..." -ForegroundColor Yellow

if (Test-CommandExists npm) {
    Write-Host "  → Установка Firebase CLI..." -ForegroundColor Cyan
    try {
        npm install -g firebase-tools 2>&1 | Out-Null
        Write-Host "  ✓ Firebase CLI установлен" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Ошибка установки Firebase CLI" -ForegroundColor Red
    }
} else {
    Write-Host "  ⚠ npm не найден. Пропускаем установку Firebase CLI" -ForegroundColor Yellow
}

# =============================================================================
# 7. Установка GitHub CLI
# =============================================================================
Write-Host "`n[7/9] Проверка GitHub CLI..." -ForegroundColor Yellow

if (Test-CommandExists gh) {
    $ghVersion = gh --version | Select-Object -First 1
    Write-Host "  ✓ GitHub CLI уже установлен: $ghVersion" -ForegroundColor Green
} else {
    Write-Host "  → Установка GitHub CLI через winget..." -ForegroundColor Cyan
    try {
        winget install GitHub.cli --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✓ GitHub CLI успешно установлен" -ForegroundColor Green

        # Обновление PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Host "  ✗ Ошибка установки GitHub CLI: $_" -ForegroundColor Red
    }
}

# =============================================================================
# 8. Установка базовых MCP серверов
# =============================================================================
Write-Host "`n[8/9] Установка базовых MCP серверов..." -ForegroundColor Yellow

if (Test-CommandExists npm) {
    $mcpServers = @(
        @{package="@anthropic-ai/mcp-server-filesystem"; name="Filesystem"},
        @{package="@anthropic-ai/mcp-server-github"; name="GitHub"}
    )

    foreach ($server in $mcpServers) {
        Write-Host "  → Установка MCP сервера $($server.name)..." -ForegroundColor Cyan
        try {
            npm install -g $server.package 2>&1 | Out-Null
            Write-Host "    ✓ MCP $($server.name) установлен" -ForegroundColor Green
        } catch {
            Write-Host "    ✗ Ошибка установки MCP $($server.name)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "  ✗ npm не найден. Пропускаем установку MCP серверов" -ForegroundColor Red
}

# =============================================================================
# 9. Создание конфигурации MCP для Claude Desktop
# =============================================================================
Write-Host "`n[9/9] Настройка конфигурации Claude Desktop..." -ForegroundColor Yellow

$claudeConfigPath = "$env:APPDATA\claude"
$settingsFile = "$claudeConfigPath\settings.json"

# Создаем директорию, если её нет
if (-not (Test-Path $claudeConfigPath)) {
    New-Item -ItemType Directory -Path $claudeConfigPath -Force | Out-Null
    Write-Host "  → Создана директория конфигурации: $claudeConfigPath" -ForegroundColor Cyan
}

# Создаем базовый settings.json, если его нет
if (-not (Test-Path $settingsFile)) {
    $defaultProjectsPath = "$env:USERPROFILE\Projects"

    # Спрашиваем про GitHub токен
    Write-Host "`n  → Настройка MCP серверов..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    Для работы с GitHub через MCP нужен Personal Access Token" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Как получить токен:" -ForegroundColor Cyan
    Write-Host "    1. Откройте https://github.com/settings/tokens" -ForegroundColor White
    Write-Host "    2. 'Generate new token' → 'Generate new token (classic)'" -ForegroundColor White
    Write-Host "    3. Выберите scopes: repo, read:org, read:user" -ForegroundColor White
    Write-Host "    4. Скопируйте токен (начинается с ghp_)" -ForegroundColor White
    Write-Host ""
    Write-Host "    Токен можно добавить позже в файл:" -ForegroundColor Gray
    Write-Host "    $settingsFile" -ForegroundColor Gray
    Write-Host ""
    $githubToken = Read-Host "    Введите GitHub token (или нажмите Enter, чтобы пропустить)"

    $mcpConfig = @{
        mcpServers = @{
            filesystem = @{
                command = "npx"
                args = @("-y", "@anthropic-ai/mcp-server-filesystem", $defaultProjectsPath)
            }
            github = @{
                command = "npx"
                args = @("-y", "@anthropic-ai/mcp-server-github")
                env = @{
                    GITHUB_TOKEN = if ($githubToken) { $githubToken } else { "YOUR_GITHUB_TOKEN" }
                }
            }
        }
    }

    $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsFile -Encoding UTF8
    Write-Host "  ✓ Конфигурация создана: $settingsFile" -ForegroundColor Green
} else {
    Write-Host "  ℹ Конфигурация уже существует: $settingsFile" -ForegroundColor Gray
}

# =============================================================================
# Финальная проверка и следующие шаги
# =============================================================================
Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  Установка завершена!" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Проверьте установленные инструменты:" -ForegroundColor Yellow
Write-Host ""

# Проверка всех инструментов
$checks = @(
    @{cmd="node"; args="--version"; name="Node.js"},
    @{cmd="npm"; args="--version"; name="npm"},
    @{cmd="git"; args="--version"; name="Git"},
    @{cmd="code"; args="--version"; name="VS Code"},
    @{cmd="claude"; args="--version"; name="Claude Code CLI"},
    @{cmd="codex"; args="--version"; name="Codex CLI"},
    @{cmd="gh"; args="--version"; name="GitHub CLI"},
    @{cmd="firebase"; args="--version"; name="Firebase CLI"}
)

foreach ($check in $checks) {
    try {
        $version = & $check.cmd $check.args 2>&1 | Select-Object -First 1
        Write-Host "  ✓ $($check.name): $version" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ $($check.name): не установлен" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Следующие шаги" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Desktop-приложения установлены:" -ForegroundColor Yellow
Write-Host "   • Claude Desktop (требуется подписка Claude Pro - \$20/месяц)" -ForegroundColor Gray
Write-Host "   • ChatGPT Desktop (требуется подписка ChatGPT Plus - \$20/месяц)" -ForegroundColor Gray
Write-Host ""
Write-Host "   ℹ️  Claude Code CLI и Codex CLI:" -ForegroundColor Cyan
Write-Host "   Для установки CLI-инструментов используйте:" -ForegroundColor Gray
Write-Host "   .\install-cli-tools.ps1" -ForegroundColor White
Write-Host "   (требуют API-доступа и оплаты отдельно от подписки)" -ForegroundColor Gray
Write-Host "   См. инструкцию 06-cli-tools-api.md для деталей." -ForegroundColor Gray
Write-Host ""

Write-Host "2. Установите расширения VS Code:" -ForegroundColor Yellow
Write-Host "   code --install-extension anthropic.claude-code" -ForegroundColor Cyan
Write-Host "   code --install-extension github.copilot" -ForegroundColor Cyan
Write-Host ""

Write-Host "3. Авторизуйтесь в GitHub CLI:" -ForegroundColor Yellow
Write-Host "   gh auth login" -ForegroundColor Cyan
Write-Host ""

Write-Host "4. Авторизуйтесь в Firebase CLI (если нужно):" -ForegroundColor Yellow
Write-Host "   firebase login" -ForegroundColor Cyan
Write-Host ""

Write-Host "5. Получите GitHub token для MCP (опционально):" -ForegroundColor Yellow
Write-Host "   https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host "   Scopes: repo, read:org, read:user" -ForegroundColor Gray
Write-Host "   Добавьте в $settingsFile" -ForegroundColor Gray
Write-Host ""

Write-Host "6. Перезапустите терминал для применения PATH" -ForegroundColor Yellow
Write-Host ""

Write-Host "Документация:" -ForegroundColor Yellow
Write-Host "  → 01-setup-environment.md - Основная инструкция" -ForegroundColor Gray
Write-Host "  → 02-github-ai-agents.md - Работа с GitHub" -ForegroundColor Gray
Write-Host "  → 03-firebase-integration.md - Интеграция с Firebase" -ForegroundColor Gray
Write-Host "  → 06-cli-tools-api.md - Claude Code CLI и Codex CLI (через API)" -ForegroundColor Gray
Write-Host ""

Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
