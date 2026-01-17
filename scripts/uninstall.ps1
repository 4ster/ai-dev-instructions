# =============================================================================
# Скрипт деинсталляции среды для AI-разработки
# =============================================================================
#
# Этот скрипт удаляет инструменты, установленные через windows-setup.ps1
# и install-cli-tools.ps1
#
# Использование:
#   .\uninstall.ps1                    # Интерактивный режим с запросами
#   .\uninstall.ps1 -Force             # Удаление без запросов
#   .\uninstall.ps1 -SkipDesktopApps   # Не удалять Desktop-приложения
#
# =============================================================================

param(
    [switch]$Force,              # Удалять без запросов
    [switch]$SkipDesktopApps,    # Не удалять Desktop-приложения
    [switch]$SkipCLI,            # Не удалять CLI-инструменты
    [switch]$SkipVSCode,         # Не удалять VS Code
    [switch]$SkipExtensions,     # Не удалять расширения VS Code
    [switch]$SkipConfig          # Не удалять конфигурационные файлы
)

# Проверка прав администратора
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ПРЕДУПРЕЖДЕНИЕ: Скрипт не запущен от имени администратора" -ForegroundColor Yellow
    Write-Host "Некоторые операции могут быть недоступны" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Деинсталляция среды AI-разработки" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

if (-not $Force) {
    Write-Host "⚠️  ВНИМАНИЕ!" -ForegroundColor Yellow
    Write-Host "Этот скрипт удалит инструменты, установленные для AI-разработки." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Продолжить? (y/n)"
    if ($continue -ne "y") {
        Write-Host "Деинсталляция отменена" -ForegroundColor Gray
        exit 0
    }
    Write-Host ""
}

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
# Функция для запроса подтверждения
# =============================================================================
function Confirm-Action {
    param(
        [string]$message,
        [switch]$skipIfForce
    )

    if ($Force -and $skipIfForce) {
        return $true
    }

    $response = Read-Host "$message (y/n)"
    return $response -eq "y"
}

# =============================================================================
# 1. Удаление Desktop-приложений
# =============================================================================
if (-not $SkipDesktopApps) {
    Write-Host "[1] Удаление Desktop-приложений" -ForegroundColor Yellow
    Write-Host ""

    # Claude Desktop
    if (Confirm-Action "  Удалить Claude Desktop?" -skipIfForce) {
        Write-Host "  → Удаление Claude Desktop..." -ForegroundColor Cyan
        if (Test-CommandExists winget) {
            try {
                winget uninstall --id Anthropic.Claude --silent 2>&1 | Out-Null
                Write-Host "    ✓ Claude Desktop удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⚠ winget не найден. Удалите вручную через 'Параметры → Приложения'" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ Пропущено" -ForegroundColor Gray
    }

    # ChatGPT Desktop
    if (Confirm-Action "  Удалить ChatGPT Desktop?" -skipIfForce) {
        Write-Host "  → Удаление ChatGPT Desktop..." -ForegroundColor Cyan
        if (Test-CommandExists winget) {
            try {
                winget uninstall --id OpenAI.ChatGPT --silent 2>&1 | Out-Null
                Write-Host "    ✓ ChatGPT Desktop удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⚠ winget не найден. Удалите вручную через 'Параметры → Приложения'" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ Пропущено" -ForegroundColor Gray
    }

    Write-Host ""
} else {
    Write-Host "[1] Desktop-приложения: пропущено" -ForegroundColor Gray
    Write-Host ""
}

# =============================================================================
# 2. Удаление CLI-инструментов
# =============================================================================
if (-not $SkipCLI) {
    Write-Host "[2] Удаление CLI-инструментов" -ForegroundColor Yellow
    Write-Host ""

    if (Test-CommandExists npm) {
        # Claude Code CLI
        if ((Test-CommandExists claude) -and (Confirm-Action "  Удалить Claude Code CLI?" -skipIfForce)) {
            Write-Host "  → Удаление Claude Code CLI..." -ForegroundColor Cyan
            try {
                npm uninstall -g @anthropic-ai/claude-code 2>&1 | Out-Null
                Write-Host "    ✓ Claude Code CLI удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⊖ Claude Code CLI не установлен или пропущен" -ForegroundColor Gray
        }

        # Codex CLI
        if ((Test-CommandExists codex) -and (Confirm-Action "  Удалить Codex CLI?" -skipIfForce)) {
            Write-Host "  → Удаление Codex CLI..." -ForegroundColor Cyan
            try {
                npm uninstall -g @openai/codex 2>&1 | Out-Null
                Write-Host "    ✓ Codex CLI удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⊖ Codex CLI не установлен или пропущен" -ForegroundColor Gray
        }

        # Firebase CLI
        if ((Test-CommandExists firebase) -and (Confirm-Action "  Удалить Firebase CLI?" -skipIfForce)) {
            Write-Host "  → Удаление Firebase CLI..." -ForegroundColor Cyan
            try {
                npm uninstall -g firebase-tools 2>&1 | Out-Null
                Write-Host "    ✓ Firebase CLI удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⊖ Firebase CLI не установлен или пропущен" -ForegroundColor Gray
        }

        # MCP серверы
        if (Confirm-Action "  Удалить MCP серверы?" -skipIfForce) {
            Write-Host "  → Удаление MCP серверов..." -ForegroundColor Cyan

            $mcpServers = @(
                "@anthropic-ai/mcp-server-filesystem",
                "@anthropic-ai/mcp-server-github"
            )

            foreach ($server in $mcpServers) {
                try {
                    npm uninstall -g $server 2>&1 | Out-Null
                    Write-Host "    ✓ $server удален" -ForegroundColor Green
                } catch {
                    Write-Host "    ⚠ $server : ошибка удаления" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "    ⊖ MCP серверы пропущены" -ForegroundColor Gray
        }

    } else {
        Write-Host "  ⚠ npm не найден, пропускаем CLI-инструменты" -ForegroundColor Yellow
    }

    # GitHub CLI
    if ((Test-CommandExists gh) -and (Confirm-Action "  Удалить GitHub CLI?" -skipIfForce)) {
        Write-Host "  → Удаление GitHub CLI..." -ForegroundColor Cyan
        if (Test-CommandExists winget) {
            try {
                winget uninstall --id GitHub.cli --silent 2>&1 | Out-Null
                Write-Host "    ✓ GitHub CLI удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⚠ winget не найден" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ GitHub CLI не установлен или пропущен" -ForegroundColor Gray
    }

    Write-Host ""
} else {
    Write-Host "[2] CLI-инструменты: пропущено" -ForegroundColor Gray
    Write-Host ""
}

# =============================================================================
# 3. Удаление расширений VS Code
# =============================================================================
if (-not $SkipExtensions) {
    Write-Host "[3] Удаление расширений VS Code" -ForegroundColor Yellow
    Write-Host ""

    if (Test-CommandExists code) {
        if (Confirm-Action "  Удалить расширения VS Code для AI-разработки?" -skipIfForce) {
            $extensions = @(
                "anthropic.claude-code",
                "openai.codex",
                "eamodio.gitlens",
                "usernamehw.errorlens",
                "esbenp.prettier-vscode",
                "dbaeumer.vscode-eslint"
            )

            foreach ($ext in $extensions) {
                Write-Host "  → Удаление $ext..." -ForegroundColor Cyan
                try {
                    code --uninstall-extension $ext 2>&1 | Out-Null
                    Write-Host "    ✓ $ext удален" -ForegroundColor Green
                } catch {
                    Write-Host "    ⚠ Ошибка удаления $ext" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "    ⊖ Расширения пропущены" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⊖ VS Code не установлен" -ForegroundColor Gray
    }

    Write-Host ""
} else {
    Write-Host "[3] Расширения VS Code: пропущено" -ForegroundColor Gray
    Write-Host ""
}

# =============================================================================
# 4. Удаление VS Code
# =============================================================================
if (-not $SkipVSCode) {
    Write-Host "[4] Удаление VS Code" -ForegroundColor Yellow
    Write-Host ""

    if ((Test-CommandExists code) -and (Confirm-Action "  Удалить VS Code?" -skipIfForce)) {
        Write-Host "  → Удаление VS Code..." -ForegroundColor Cyan
        if (Test-CommandExists winget) {
            try {
                winget uninstall --id Microsoft.VisualStudioCode --silent 2>&1 | Out-Null
                Write-Host "    ✓ VS Code удален" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    ⚠ winget не найден" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ VS Code не установлен или пропущен" -ForegroundColor Gray
    }

    Write-Host ""
} else {
    Write-Host "[4] VS Code: пропущено" -ForegroundColor Gray
    Write-Host ""
}

# =============================================================================
# 5. Удаление Node.js и Git
# =============================================================================
Write-Host "[5] Базовые инструменты (Node.js, Git)" -ForegroundColor Yellow
Write-Host ""

# Node.js
if ((Test-CommandExists node) -and (Confirm-Action "  Удалить Node.js?" -skipIfForce)) {
    Write-Host "  → Удаление Node.js..." -ForegroundColor Cyan
    if (Test-CommandExists winget) {
        try {
            winget uninstall --id OpenJS.NodeJS --silent 2>&1 | Out-Null
            Write-Host "    ✓ Node.js удален" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⚠ winget не найден" -ForegroundColor Yellow
    }
} else {
    Write-Host "    ⊖ Node.js не установлен или пропущен" -ForegroundColor Gray
}

# Git
if ((Test-CommandExists git) -and (Confirm-Action "  Удалить Git?" -skipIfForce)) {
    Write-Host "  → Удаление Git..." -ForegroundColor Cyan
    if (Test-CommandExists winget) {
        try {
            winget uninstall --id Git.Git --silent 2>&1 | Out-Null
            Write-Host "    ✓ Git удален" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⚠ winget не найден" -ForegroundColor Yellow
    }
} else {
    Write-Host "    ⊖ Git не установлен или пропущен" -ForegroundColor Gray
}

Write-Host ""

# =============================================================================
# 6. Удаление конфигурационных файлов
# =============================================================================
if (-not $SkipConfig) {
    Write-Host "[6] Удаление конфигурационных файлов" -ForegroundColor Yellow
    Write-Host ""

    # Claude Desktop config
    $claudeDesktopConfig = "$env:APPDATA\Claude\claude_desktop_config.json"
    if ((Test-Path $claudeDesktopConfig) -and (Confirm-Action "  Удалить конфигурацию Claude Desktop?" -skipIfForce)) {
        Write-Host "  → Удаление $claudeDesktopConfig..." -ForegroundColor Cyan
        try {
            Remove-Item $claudeDesktopConfig -Force
            Write-Host "    ✓ Конфигурация Claude Desktop удалена" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ Конфигурация Claude Desktop не найдена или пропущена" -ForegroundColor Gray
    }

    # Claude Code config (settings.json)
    $claudeCodeConfig = "$env:APPDATA\claude\settings.json"
    if ((Test-Path $claudeCodeConfig) -and (Confirm-Action "  Удалить конфигурацию Claude Code?" -skipIfForce)) {
        Write-Host "  → Удаление $claudeCodeConfig..." -ForegroundColor Cyan
        try {
            Remove-Item $claudeCodeConfig -Force
            Write-Host "    ✓ Конфигурация Claude Code удалена" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ Конфигурация Claude Code не найдена или пропущена" -ForegroundColor Gray
    }

    # Удаление переменных окружения с API-ключами
    if (Confirm-Action "  Удалить API-ключи из переменных окружения?" -skipIfForce) {
        Write-Host "  → Удаление переменных окружения..." -ForegroundColor Cyan
        try {
            [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $null, "User")
            [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $null, "User")
            Write-Host "    ✓ API-ключи удалены" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠ Ошибка удаления: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    ⊖ API-ключи сохранены" -ForegroundColor Gray
    }

    Write-Host ""
} else {
    Write-Host "[6] Конфигурационные файлы: пропущено" -ForegroundColor Gray
    Write-Host ""
}

# =============================================================================
# Итоги
# =============================================================================
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Деинсталляция завершена" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "ℹ️  Дополнительные шаги (опционально):" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Удалите папку Claude Desktop (если осталась):" -ForegroundColor White
Write-Host "   $env:APPDATA\Claude" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Очистите глобальные пакеты npm:" -ForegroundColor White
Write-Host "   npm list -g --depth=0" -ForegroundColor Gray
Write-Host "   npm uninstall -g <package-name>" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Удалите настройки VS Code (если нужно):" -ForegroundColor White
Write-Host "   $env:APPDATA\Code" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Перезагрузите компьютер для полного удаления" -ForegroundColor White
Write-Host ""

Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
