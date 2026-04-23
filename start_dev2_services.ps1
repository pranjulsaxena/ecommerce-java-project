# E-Commerce Developer 2 Services Startup Script (PowerShell)
# This script starts RMI registry and PaymentServer for local development

param(
    [switch]$StopServices
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Classpath = "$ProjectRoot\target\classes"
$M2Repo = Join-Path $HOME ".m2\repository"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting E-Commerce Developer 2 Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Build classpath with all JARs
Write-Host "Building classpath..." -ForegroundColor Yellow
try {
    Get-ChildItem -Path $M2Repo -Recurse -Filter "*.jar" -ErrorAction SilentlyContinue | ForEach-Object {
        $Classpath += ";$($_.FullName)"
    }
    Write-Host "Classpath built successfully" -ForegroundColor Green
} catch {
    Write-Host "Warning: Failed to build classpath from M2 repository" -ForegroundColor Yellow
}

Write-Host ""

# Function to kill services on exit
function Stop-Services {
    Write-Host ""
    Write-Host "Stopping services..." -ForegroundColor Yellow
    
    # Kill RMI Registry
    $rmiProcess = Get-Process rmiregistry -ErrorAction SilentlyContinue
    if ($rmiProcess) {
        Stop-Process -InputObject $rmiProcess -Force
        Write-Host "✓ RMI Registry stopped" -ForegroundColor Green
    }
    
    # Kill Java processes running PaymentServer
    Get-Process java -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*PaymentServerImpl*"
    } | ForEach-Object {
        Stop-Process -InputObject $_ -Force
        Write-Host "✓ PaymentServer stopped" -ForegroundColor Green
    }
    
    Write-Host "Services stopped." -ForegroundColor Green
}

# Handle Ctrl+C gracefully
$null = Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    Stop-Services
}

# Start services
try {
    Write-Host "[1/2] Starting RMI Registry on port 1099..." -ForegroundColor Cyan
    Start-Process rmiregistry -ArgumentList 1099 -WindowStyle Hidden -PassThru | Out-Null
    Start-Sleep -Seconds 2
    Write-Host "      ✓ RMI Registry started" -ForegroundColor Green
    Write-Host ""

    Write-Host "[2/2] Starting PaymentServer (RMI Service)..." -ForegroundColor Cyan
    Push-Location $ProjectRoot
    
    # Start PaymentServer in background
    $job = Start-Job -ScriptBlock {
        param($cp, $root)
        Set-Location $root
        & java -cp $cp com.ecommerce.payment.PaymentServerImpl
    } -ArgumentList $Classpath, $ProjectRoot
    
    Start-Sleep -Seconds 3
    
    if ($job.State -eq "Running") {
        Write-Host "      ✓ PaymentServer started" -ForegroundColor Green
    } elseif ($job.State -eq "Failed") {
        Write-Host "      ✗ Failed to start PaymentServer" -ForegroundColor Red
        Receive-Job -Job $job
        Stop-Job -Job $job
        exit 1
    }

    Pop-Location

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ Services Started Successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "RMI Registry:   localhost:1099"
    Write-Host "PaymentService: PaymentService (bound to RMI)"
    Write-Host ""
    Write-Host "Service Status:"
    Write-Host "  RMI Registry: Running"
    Write-Host "  PaymentServer: Running (Job ID: $($job.Id))"
    Write-Host ""
    Write-Host "To stop services, press Ctrl+C"
    Write-Host ""
    Write-Host "Ready for testing with Tomcat server." -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Green
    
    # Keep the script running and monitoring services
    while ($true) {
        if ($job.State -ne "Running") {
            Write-Host "PaymentServer stopped unexpectedly!" -ForegroundColor Red
            Receive-Job -Job $job
            break
        }
        Start-Sleep -Seconds 2
    }

} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Stop-Services
    exit 1
}
