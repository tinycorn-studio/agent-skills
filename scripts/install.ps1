# install.ps1 - Link (Directory Junction) all skills into AI Agent hosts on Windows
#
# Supported hosts:
#   - Google Antigravity (~/.gemini/config/skills)
#   - Claude Code        (~/.claude/skills)
#   - opencode           (~/.config/opencode/skills)
#   - Agent Skills spec  (~/.agents/skills)
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SkillsSource = Join-Path $RepoRoot "skills"

$Targets = @(
    (Join-Path $HOME ".gemini\config\skills"),     # Google Antigravity
    (Join-Path $HOME ".claude\skills"),            # Claude Code
    (Join-Path $HOME ".config\opencode\skills"),   # opencode
    (Join-Path $HOME ".agents\skills")             # Agent Skills spec
)

$SkillFolders = Get-ChildItem -Path $SkillsSource -Directory

foreach ($TargetDir in $Targets) {
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    }

    foreach ($Skill in $SkillFolders) {
        $LinkPath = Join-Path $TargetDir $Skill.Name
        if (Test-Path $LinkPath) {
            Remove-Item -Path $LinkPath -Recurse -Force
        }
        # Use Directory Junction (/J) so Administrator privileges are not required on Windows
        New-Item -ItemType Junction -Path $LinkPath -Target $Skill.FullName | Out-Null
        Write-Host "Linked $($Skill.Name) -> $TargetDir" -ForegroundColor Green
    }
}

Write-Host "`nOK - Linked $($SkillFolders.Count) skills across $($Targets.Count) agent directories." -ForegroundColor Cyan
