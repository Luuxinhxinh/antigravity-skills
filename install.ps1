<#
.SYNOPSIS
    Script cài đặt / đồng bộ Antigravity Skills từ repo Luuxinhxinh/antigravity-skills
.DESCRIPTION
    Tự động clone hoặc pull các skill mới nhất và cài vào các thư mục Antigravity trên Windows:
    - ~/.gemini/config/skills (Global Config)
    - ~/.gemini/antigravity/skills (Runtime Engine)
    - ~/.gemini/antigravity-ide/skills (IDE Application)
    - ~/.gemini/config/rules/skill-router.md (Bộ điều phối tự động)
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Write-Host "🚀 Đang tiến hành cài đặt kho Antigravity Skills..." -ForegroundColor Cyan

$userHome = [System.Environment]::GetFolderPath('UserProfile')
$targetLocations = @(
    "$userHome\.gemini\config\skills",
    "$userHome\.gemini\antigravity\skills",
    "$userHome\.gemini\antigravity-ide\skills"
)
$ruleLocation = "$userHome\.gemini\config\rules"

# Tạo thư mục tạm để kéo repo
$tempDir = Join-Path $env:TEMP "antigravity-skills-installer"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "📦 Đang tải dữ liệu từ GitHub (Luuxinhxinh/antigravity-skills)..." -ForegroundColor Yellow
git clone --depth 1 https://github.com/Luuxinhxinh/antigravity-skills.git $tempDir

# Lấy danh sách thư mục skills (bỏ qua .git và các file lẻ)
$skillDirs = Get-ChildItem -Path $tempDir -Directory | Where-Object { $_.Name -ne ".git" }

foreach ($loc in $targetLocations) {
    if (!(Test-Path $loc)) {
        New-Item -ItemType Directory -Path $loc -Force | Out-Null
    }
    Write-Host "📂 Cài đặt vào: $loc" -ForegroundColor Green
    foreach ($dir in $skillDirs) {
        Copy-Item -Path $dir.FullName -Destination "$loc\$($dir.Name)" -Recurse -Force
    }
}

# Cài đặt file điều phối skill-router.md vào rules
if (!(Test-Path $ruleLocation)) {
    New-Item -ItemType Directory -Path $ruleLocation -Force | Out-Null
}
$routerSource = Join-Path $tempDir "skill-router.md"
if (Test-Path $routerSource) {
    Copy-Item -Path $routerSource -Destination "$ruleLocation\skill-router.md" -Force
    Write-Host "🧠 Đã kích hoạt Bộ điều phối kỹ năng: $ruleLocation\skill-router.md" -ForegroundColor Magenta
}

# Dọn dẹp thư mục tạm
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`n✅ CÀI ĐẶT THÀNH CÔNG!" -ForegroundColor Green
Write-Host "🎉 Tổng cộng $($skillDirs.Count) skills và Bộ điều phối trung tâm đã sẵn sàng hoạt động trên Antigravity IDE!" -ForegroundColor Cyan
