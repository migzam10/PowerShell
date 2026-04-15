function Mostrar-Menu {
    Clear-Host
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host "       HERRAMIENTAS DE MANTENIMIENTO DEL SO      " -ForegroundColor Cyan
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host "1. Optimizar/Desfragmentar unidad C"
    Write-Host "2. Corregir errores del Sistema con SFC /scannow"
    Write-Host "3. Corregir errores del Sistema con DISM" 
    Write-Host "4. Salir"
    Write-Host "=================================================" -ForegroundColor Cyan
}

do {
    Mostrar-Menu
    $opcion = Read-Host "`nIngresa el número de la opción que deseas ejecutar"
    
    switch ($opcion) {
        "1" {
            Write-Host "`nDetectando tipo de disco..." -ForegroundColor Cyan
            # Usamos Get-Volume (nativo) en lugar de Get-DriveType
            $vol = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue
            
            if ($vol) {
                $type = $vol.MediaType
                switch ($type) {
                    "SSD" {
                        Write-Host "SSD detectado. Ejecutando TRIM..." -ForegroundColor Yellow
                        Optimize-Volume -DriveLetter C -ReTrim -Verbose
                        Write-Host "TRIM completado." -ForegroundColor Green
                    }
                    "HDD" {
                        Write-Host "HDD detectado. Desfragmentando..." -ForegroundColor Yellow
                        Optimize-Volume -DriveLetter C -Defrag -Verbose
                        Write-Host "Desfragmentación completada." -ForegroundColor Green
                    }
                    default {
                        Write-Host "Tipo de disco no determinado ($type). Ejecutando optimización genérica..." -ForegroundColor Yellow
                        Optimize-Volume -DriveLetter C -Verbose
                        Write-Host "Optimización completada." -ForegroundColor Green
                    }
                }
            } else {
                Write-Host "No se pudo obtener la información de la unidad C." -ForegroundColor Red
            }
            Read-Host "`nPresiona Enter para continuar"
        }
        "2" {
            Write-Host "`nEjecutando sfc /scannow para corregir errores en el sistema..." -ForegroundColor Cyan
            sfc /scannow
            Read-Host "`nPresiona Enter para continuar"
        }
        "3" {
            Write-Host "`nPaso 1/3 — CheckHealth..." -ForegroundColor Cyan
            DISM /Online /Cleanup-Image /CheckHealth
        
            Write-Host "Paso 2/3 — ScanHealth..." -ForegroundColor Cyan
            DISM /Online /Cleanup-Image /ScanHealth
        
            Write-Host "Paso 3/3 — RestoreHealth..." -ForegroundColor Cyan
            DISM /Online /Cleanup-Image /RestoreHealth
            
            Read-Host "`nPresiona Enter para continuar"
        }
        "4" {
            Write-Host "`nSaliendo del programa..." -ForegroundColor Yellow
        }
        default {
            Write-Host "`nOpción no válida. Por favor, selecciona una opción válida." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($opcion -ne "4")