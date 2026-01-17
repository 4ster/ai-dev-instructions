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
# 1. Установка Node.js
# =============================================================================
Write-Host "[1/8] Проверка Node.js..." -ForegroundColor Yellow

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
# 2. Установка Git
# =============================================================================
Write-Host "`n[2/8] Проверка Git..." -ForegroundColor Yellow

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
# 3. Установка VS Code
# =============================================================================
Write-Host "`n[3/8] Проверка VS Code..." -ForegroundColor Yellow

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
# 4. Установка расширений VS Code
# =============================================================================
Write-Host "`n[4/8] Установка расширений VS Code..." -ForegroundColor Yellow

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
# 5. Установка CLI-инструментов через npm
# =============================================================================
Write-Host "`n[5/8] Установка CLI-инструментов..." -ForegroundColor Yellow

if (Test-CommandExists npm) {
    # Claude Code CLI
    Write-Host "  → Установка Claude Code CLI..." -ForegroundColor Cyan
    try {
        npm install -g @anthropic-ai/claude-code 2>&1 | Out-Null
        Write-Host "    ✓ Claude Code CLI установлен" -ForegroundColor Green
    } catch {
        Write-Host "    ✗ Ошибка установки Claude Code CLI" -ForegroundColor Red
    }

    # Codex CLI
    Write-Host "  → Установка Codex CLI..." -ForegroundColor Cyan
    try {
        npm install -g @openai/codex 2>&1 | Out-Null
        Write-Host "    ✓ Codex CLI установлен" -ForegroundColor Green
    } catch {
        Write-Host "    ✗ Ошибка установки Codex CLI" -ForegroundColor Red
    }

    # Firebase CLI
    Write-Host "  → Установка Firebase CLI..." -ForegroundColor Cyan
    try {
        npm install -g firebase-tools 2>&1 | Out-Null
        Write-Host "    ✓ Firebase CLI установлен" -ForegroundColor Green
    } catch {
        Write-Host "    ✗ Ошибка установки Firebase CLI" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ npm не найден. Установите Node.js и перезапустите скрипт" -ForegroundColor Red
}

# =============================================================================
# 6. Установка GitHub CLI
# =============================================================================
Write-Host "`n[6/8] Проверка GitHub CLI..." -ForegroundColor Yellow

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
# 7. Установка базовых MCP серверов
# =============================================================================
Write-Host "`n[7/8] Установка базовых MCP серверов..." -ForegroundColor Yellow

if (Test-CommandExists npm) {
    $mcpServers = @(
        @{package="@anthropic-ai/mcp-server-filesystem"; name="Filesystem"},
        @{package="@anthropic-ai/mcp-server-github"; name="GitHub"},
        @{package="@anthropic-ai/mcp-server-memory"; name="Memory"}
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
# 8. Создание конфигурации MCP для Claude Code CLI
# =============================================================================
Write-Host "`n[8/8] Настройка конфигурации Claude Code..." -ForegroundColor Yellow

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
    Write-Host "    Для работы с GitHub через MCP нужен токен (можно добавить позже)" -ForegroundColor Gray
    $githubToken = Read-Host "    Введите GitHub token (или оставьте пустым)"

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
            memory = @{
                command = "npx"
                args = @("-y", "@anthropic-ai/mcp-server-memory")
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

Write-Host "1. Настройте API-ключи:" -ForegroundColor Yellow
Write-Host "   • Anthropic (Claude): https://console.anthropic.com/" -ForegroundColor Gray
Write-Host "   • OpenAI (Codex): https://platform.openai.com/" -ForegroundColor Gray
Write-Host ""
Write-Host "   Добавьте их в переменные окружения:" -ForegroundColor Gray
Write-Host '   [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-...", "User")' -ForegroundColor Cyan
Write-Host '   [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-...", "User")' -ForegroundColor Cyan
Write-Host ""

Write-Host "2. Авторизуйтесь в GitHub CLI:" -ForegroundColor Yellow
Write-Host "   gh auth login" -ForegroundColor Cyan
Write-Host ""

Write-Host "3. Авторизуйтесь в Firebase CLI:" -ForegroundColor Yellow
Write-Host "   firebase login" -ForegroundColor Cyan
Write-Host ""

Write-Host "4. Получите GitHub token для MCP:" -ForegroundColor Yellow
Write-Host "   https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host "   Scopes: repo, read:org, read:user" -ForegroundColor Gray
Write-Host "   Добавьте в $settingsFile" -ForegroundColor Gray
Write-Host ""

Write-Host "5. Перезапустите терминал для применения PATH" -ForegroundColor Yellow
Write-Host ""

Write-Host "Документация:" -ForegroundColor Yellow
Write-Host "  → 01-setup-environment.md - Подробная инструкция" -ForegroundColor Gray
Write-Host "  → 02-github-ai-agents.md - Работа с GitHub" -ForegroundColor Gray
Write-Host "  → 03-firebase-integration.md - Интеграция с Firebase" -ForegroundColor Gray
Write-Host ""

Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
