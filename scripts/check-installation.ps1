# =============================================================================
# Скрипт проверки установки среды для AI-разработки
# =============================================================================
#
# Этот скрипт проверяет, что все необходимые инструменты установлены корректно
#
# =============================================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Проверка установки AI-dev среды" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# =============================================================================
# Функция для проверки команды
# =============================================================================
function Test-Tool {
    param(
        [string]$command,
        [string]$args,
        [string]$name,
        [string]$requiredVersion = $null
    )

    try {
        $output = & $command $args 2>&1 | Select-Object -First 1
        Write-Host "  ✓ $name" -ForegroundColor Green -NoNewline
        Write-Host " - $output" -ForegroundColor Gray
        return $true
    } catch {
        Write-Host "  ✗ $name" -ForegroundColor Red -NoNewline
        Write-Host " - не установлен" -ForegroundColor Gray
        return $false
    }
}

# =============================================================================
# 1. Базовые инструменты
# =============================================================================
Write-Host "[1] Базовые инструменты" -ForegroundColor Yellow
Write-Host ""

$nodeOk = Test-Tool "node" "--version" "Node.js"
$npmOk = Test-Tool "npm" "--version" "npm"
$gitOk = Test-Tool "git" "--version" "Git"
$codeOk = Test-Tool "code" "--version" "VS Code"

Write-Host ""

# =============================================================================
# 2. Внешние CLI
# =============================================================================
Write-Host "[2] Внешние CLI" -ForegroundColor Yellow
Write-Host ""

$ghOk = Test-Tool "gh" "--version" "GitHub CLI"
$firebaseOk = Test-Tool "firebase" "--version" "Firebase CLI"

Write-Host ""

# =============================================================================
# 3. Проверка конфигурации Claude Desktop (MCP)
# =============================================================================
Write-Host "[3] Конфигурация Claude Desktop (MCP)" -ForegroundColor Yellow
Write-Host ""

$claudeConfigPath = "$env:APPDATA\claude"
$settingsFile = "$claudeConfigPath\settings.json"

if (Test-Path $settingsFile) {
    Write-Host "  ✓ Файл конфигурации существует" -ForegroundColor Green
    Write-Host "    $settingsFile" -ForegroundColor Gray

    try {
        $config = Get-Content $settingsFile | ConvertFrom-Json
        if ($config.mcpServers) {
            Write-Host "  ✓ MCP серверы настроены:" -ForegroundColor Green
            foreach ($serverName in $config.mcpServers.PSObject.Properties.Name) {
                Write-Host "    • $serverName" -ForegroundColor Gray
            }
        } else {
            Write-Host "  ⚠ MCP серверы не настроены" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  ⚠ Ошибка чтения конфигурации" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✗ Файл конфигурации не найден" -ForegroundColor Red
    Write-Host "    Ожидается: $settingsFile" -ForegroundColor Gray
}

Write-Host ""

# =============================================================================
# 6. Проверка авторизации
# =============================================================================
Write-Host "[4] Авторизация в сервисах" -ForegroundColor Yellow
Write-Host ""

# GitHub
if ($ghOk) {
    try {
        $ghStatus = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ GitHub CLI - авторизован" -ForegroundColor Green
        } else {
            Write-Host "  ✗ GitHub CLI - не авторизован" -ForegroundColor Red
            Write-Host "    Выполните: gh auth login" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ✗ GitHub CLI - не авторизован" -ForegroundColor Red
    }
}

# Firebase
if ($firebaseOk) {
    try {
        $firebaseProjects = firebase projects:list 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Firebase CLI - авторизован" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Firebase CLI - не авторизован" -ForegroundColor Red
            Write-Host "    Выполните: firebase login" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ✗ Firebase CLI - не авторизован" -ForegroundColor Red
    }
}

Write-Host ""

# =============================================================================
# 7. Проверка расширений VS Code
# =============================================================================
Write-Host "[5] Расширения VS Code" -ForegroundColor Yellow
Write-Host ""

if ($codeOk) {
    $requiredExtensions = @(
        @{id="anthropic.claude-code"; name="Claude for VS Code"},
        @{id="openai.codex"; name="Codex (OpenAI)"},
        @{id="eamodio.gitlens"; name="GitLens"},
        @{id="usernamehw.errorlens"; name="Error Lens"}
    )

    $installedExtensions = code --list-extensions 2>&1

    foreach ($ext in $requiredExtensions) {
        if ($installedExtensions -contains $ext.id) {
            Write-Host "  ✓ $($ext.name)" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $($ext.name)" -ForegroundColor Red
            Write-Host "    Установите: code --install-extension $($ext.id)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "  ⚠ VS Code не установлен, пропускаем проверку расширений" -ForegroundColor Yellow
}

Write-Host ""

# =============================================================================
# Итоговая статистика
# =============================================================================
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Итоговая статистика" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$totalChecks = 5
$passedChecks = 0

if ($nodeOk) { $passedChecks++ }
if ($gitOk) { $passedChecks++ }
if ($codeOk) { $passedChecks++ }
if ($ghOk) { $passedChecks++ }
if ($firebaseOk) { $passedChecks++ }

$percentage = [math]::Round(($passedChecks / $totalChecks) * 100)

Write-Host "Установлено: $passedChecks из $totalChecks инструментов ($percentage%)" -ForegroundColor Cyan
Write-Host ""

if ($passedChecks -eq $totalChecks) {
    Write-Host "🎉 Отлично! Все базовые инструменты установлены!" -ForegroundColor Green
} elseif ($passedChecks -ge 3) {
    Write-Host "✅ Хорошо! Основные инструменты установлены." -ForegroundColor Yellow
    Write-Host "   Установите оставшиеся по необходимости." -ForegroundColor Yellow
} else {
    Write-Host "⚠️  Необходимо установить базовые инструменты." -ForegroundColor Red
    Write-Host "   Используйте скрипт windows-setup.ps1 для автоматической установки." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Рекомендации:" -ForegroundColor Yellow
Write-Host ""

Write-Host "  → Установите Desktop-приложения для AI:" -ForegroundColor Cyan
Write-Host "    • Claude Desktop: https://claude.ai/download" -ForegroundColor Gray
Write-Host "    • ChatGPT Desktop: https://openai.com/chatgpt/download" -ForegroundColor Gray
Write-Host ""

Write-Host "  → Установите расширения VS Code:" -ForegroundColor Cyan
Write-Host "    code --install-extension anthropic.claude-code" -ForegroundColor Gray
Write-Host "    code --install-extension openai.codex" -ForegroundColor Gray
Write-Host ""

if ($ghOk) {
    $ghStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  → Авторизуйтесь в GitHub: gh auth login" -ForegroundColor Cyan
    }
}

if ($firebaseOk) {
    $firebaseProjects = firebase projects:list 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  → Авторизуйтесь в Firebase: firebase login" -ForegroundColor Cyan
    }
}

if (-not (Test-Path $settingsFile)) {
    Write-Host "  → Настройте MCP серверы в:" -ForegroundColor Cyan
    Write-Host "    $settingsFile" -ForegroundColor Gray
}

Write-Host ""
Write-Host "  ℹ️  Для CLI через API см. инструкцию 06-cli-tools-api.md" -ForegroundColor Gray
Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
