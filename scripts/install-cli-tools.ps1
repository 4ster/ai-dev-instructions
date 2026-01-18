# =============================================================================
# Скрипт установки Codex CLI
# =============================================================================
#
# ⚠️ ВАЖНО: Этот инструмент требует API-доступа и оплаты отдельно от подписки!
#
# Перед использованием:
# 1. Получите API-ключ OpenAI: https://platform.openai.com/
# 2. Прочитайте инструкцию: 06-cli-tools-api.md
#
# =============================================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Установка Codex CLI" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "⚠️  ВНИМАНИЕ!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Этот инструмент требует:" -ForegroundColor Yellow
Write-Host "  • API-ключ OpenAI (не подписку!)" -ForegroundColor White
Write-Host "  • Оплату по модели pay-as-you-go" -ForegroundColor White
Write-Host "  • Отдельную регистрацию в API-консоли OpenAI" -ForegroundColor White
Write-Host ""
Write-Host "Если у вас есть подписка ChatGPT Plus," -ForegroundColor Yellow
Write-Host "используйте ChatGPT Desktop вместо CLI!" -ForegroundColor Yellow
Write-Host ""

$continue = Read-Host "Продолжить установку Codex CLI? (y/n)"
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
Write-Host "[1/2] Проверка Node.js..." -ForegroundColor Yellow

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
# Установка Codex CLI (OpenAI)
# =============================================================================
Write-Host "`n[2/2] Установка Codex CLI..." -ForegroundColor Yellow

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

Write-Host "Для работы Codex CLI нужен API-ключ OpenAI:" -ForegroundColor Yellow
Write-Host ""

# OpenAI API Key
Write-Host "OpenAI API Key (для Codex CLI)" -ForegroundColor Cyan
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
if (Test-CommandExists codex) {
    Write-Host "  • Codex CLI" -ForegroundColor Gray
}
Write-Host ""

Write-Host "Следующие шаги:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Перезапустите терминал для применения переменных окружения" -ForegroundColor White
Write-Host ""
Write-Host "2. Проверьте установку:" -ForegroundColor White
Write-Host "   codex --version" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Проверьте API-ключ:" -ForegroundColor White
Write-Host "   echo `$env:OPENAI_API_KEY" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Используйте CLI:" -ForegroundColor White
Write-Host "   codex 'объясни как работает async/await'" -ForegroundColor Cyan
Write-Host ""

Write-Host "⚠️  Важно:" -ForegroundColor Yellow
Write-Host "  • Установите лимиты расходов в консоли API" -ForegroundColor White
Write-Host "  • OpenAI: https://platform.openai.com/settings/organization/limits" -ForegroundColor Gray
Write-Host ""
Write-Host "  • Мониторьте использование API:" -ForegroundColor White
Write-Host "  • OpenAI: https://platform.openai.com/usage" -ForegroundColor Gray
Write-Host ""

Write-Host "Документация: 06-cli-tools-api.md" -ForegroundColor Gray
Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
