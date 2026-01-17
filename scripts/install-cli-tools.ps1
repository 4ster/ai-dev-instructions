# =============================================================================
# Скрипт установки Claude Code CLI и Codex CLI
# =============================================================================
#
# ⚠️ ВАЖНО: Эти инструменты требуют API-доступа и оплаты отдельно от подписки!
#
# Перед использованием:
# 1. Получите API-ключ Anthropic: https://console.anthropic.com/
# 2. Получите API-ключ OpenAI: https://platform.openai.com/
# 3. Прочитайте инструкцию: 06-cli-tools-api.md
#
# =============================================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Установка CLI-инструментов для AI" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "⚠️  ВНИМАНИЕ!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Эти инструменты требуют:" -ForegroundColor Yellow
Write-Host "  • API-ключи (не подписку!)" -ForegroundColor White
Write-Host "  • Оплату по модели pay-as-you-go" -ForegroundColor White
Write-Host "  • Отдельную регистрацию в API-консолях" -ForegroundColor White
Write-Host ""
Write-Host "Если у вас есть подписка Claude Pro или ChatGPT Plus," -ForegroundColor Yellow
Write-Host "используйте Desktop-приложения вместо CLI!" -ForegroundColor Yellow
Write-Host ""

$continue = Read-Host "Продолжить установку CLI-инструментов? (y/n)"
if ($continue -ne "y") {
    Write-Host "Установка отменена" -ForegroundColor Gray
    exit 0
}

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
# Проверка Node.js
# =============================================================================
Write-Host "[1/3] Проверка Node.js..." -ForegroundColor Yellow

if (-not (Test-CommandExists node)) {
    Write-Host "  ✗ Node.js не установлен!" -ForegroundColor Red
    Write-Host "    Установите Node.js перед продолжением:" -ForegroundColor Yellow
    Write-Host "    https://nodejs.org/" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    Или запустите основной скрипт установки:" -ForegroundColor Yellow
    Write-Host "    .\windows-setup.ps1" -ForegroundColor White
    pause
    exit 1
}

$nodeVersion = node --version
Write-Host "  ✓ Node.js установлен: $nodeVersion" -ForegroundColor Green

# =============================================================================
# Установка Claude Code CLI
# =============================================================================
Write-Host "`n[2/3] Установка Claude Code CLI..." -ForegroundColor Yellow

if (Test-CommandExists claude) {
    $claudeVersion = claude --version
    Write-Host "  ✓ Claude Code CLI уже установлен: $claudeVersion" -ForegroundColor Green
} else {
    Write-Host "  → Установка через npm..." -ForegroundColor Cyan
    try {
        npm install -g @anthropic-ai/claude-code
        Write-Host "  ✓ Claude Code CLI установлен" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Ошибка установки Claude Code CLI: $_" -ForegroundColor Red
    }
}

# =============================================================================
# Установка Codex CLI (OpenAI)
# =============================================================================
Write-Host "`n[3/3] Установка Codex CLI..." -ForegroundColor Yellow

if (Test-CommandExists codex) {
    $codexVersion = codex --version
    Write-Host "  ✓ Codex CLI уже установлен: $codexVersion" -ForegroundColor Green
} else {
    Write-Host "  → Установка через npm..." -ForegroundColor Cyan
    try {
        npm install -g @openai/codex
        Write-Host "  ✓ Codex CLI установлен" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Ошибка установки Codex CLI: $_" -ForegroundColor Red
    }
}

# =============================================================================
# Настройка API-ключей
# =============================================================================
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Настройка API-ключей" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Для работы CLI-инструментов нужны API-ключи:" -ForegroundColor Yellow
Write-Host ""

# Anthropic API Key
Write-Host "1. Anthropic API Key (для Claude Code CLI)" -ForegroundColor Cyan
Write-Host "   → Получить: https://console.anthropic.com/settings/keys" -ForegroundColor Gray
Write-Host "   → Формат: sk-ant-..." -ForegroundColor Gray
Write-Host ""
$anthropicKey = Read-Host "   Введите ANTHROPIC_API_KEY (или Enter для пропуска)"

if ($anthropicKey) {
    [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $anthropicKey, "User")
    $env:ANTHROPIC_API_KEY = $anthropicKey
    Write-Host "   ✓ ANTHROPIC_API_KEY сохранен" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Пропущено. Настройте вручную позже:" -ForegroundColor Yellow
    Write-Host "     [Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', 'sk-ant-...', 'User')" -ForegroundColor Gray
}

Write-Host ""

# OpenAI API Key
Write-Host "2. OpenAI API Key (для Codex CLI)" -ForegroundColor Cyan
Write-Host "   → Получить: https://platform.openai.com/api-keys" -ForegroundColor Gray
Write-Host "   → Формат: sk-..." -ForegroundColor Gray
Write-Host ""
$openaiKey = Read-Host "   Введите OPENAI_API_KEY (или Enter для пропуска)"

if ($openaiKey) {
    [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $openaiKey, "User")
    $env:OPENAI_API_KEY = $openaiKey
    Write-Host "   ✓ OPENAI_API_KEY сохранен" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Пропущено. Настройте вручную позже:" -ForegroundColor Yellow
    Write-Host "     [Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'sk-...', 'User')" -ForegroundColor Gray
}

# =============================================================================
# Итоги
# =============================================================================
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Установка завершена" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✓ Установленные инструменты:" -ForegroundColor Green
if (Test-CommandExists claude) {
    Write-Host "  • Claude Code CLI" -ForegroundColor Gray
}
if (Test-CommandExists codex) {
    Write-Host "  • Codex CLI" -ForegroundColor Gray
}
Write-Host ""

Write-Host "Следующие шаги:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Перезапустите терминал для применения переменных окружения" -ForegroundColor White
Write-Host ""
Write-Host "2. Проверьте установку:" -ForegroundColor White
Write-Host "   claude --version" -ForegroundColor Cyan
Write-Host "   codex --version" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Проверьте API-ключи:" -ForegroundColor White
Write-Host "   echo `$env:ANTHROPIC_API_KEY" -ForegroundColor Cyan
Write-Host "   echo `$env:OPENAI_API_KEY" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Используйте CLI:" -ForegroundColor White
Write-Host "   claude 'создай простой HTTP-сервер на Node.js'" -ForegroundColor Cyan
Write-Host "   codex 'объясни как работает async/await'" -ForegroundColor Cyan
Write-Host ""

Write-Host "⚠️  Важно:" -ForegroundColor Yellow
Write-Host "  • Установите лимиты расходов в консолях API" -ForegroundColor White
Write-Host "  • Anthropic: https://console.anthropic.com/settings/limits" -ForegroundColor Gray
Write-Host "  • OpenAI: https://platform.openai.com/settings/organization/limits" -ForegroundColor Gray
Write-Host ""
Write-Host "  • Мониторьте использование API:" -ForegroundColor White
Write-Host "  • Anthropic: https://console.anthropic.com/settings/usage" -ForegroundColor Gray
Write-Host "  • OpenAI: https://platform.openai.com/usage" -ForegroundColor Gray
Write-Host ""

Write-Host "Документация: 06-cli-tools-api.md" -ForegroundColor Gray
Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
