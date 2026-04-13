function Mostrar-Menu {
    Write-Host "Selecciona una opción:"
    Write-Host "1. Desfragmentar unidad C"
    Write-Host "2. Corregir errores del Sistema con SFC /scannow"
	Write-Host "3. Corregir errores del Sistema con DISM" 
    Write-Host "4. Salir"
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Ingresa el número de la opción que deseas ejecutar"
    
    switch ($opcion) {
        1 {
            Write-Info "Detectando tipo de disco..."
			$type = Get-DriveType "C"
			switch ($type) {
				"SSD" {
					Write-Warn "SSD detectado. Ejecutando TRIM..."
					Optimize-Volume -DriveLetter C -ReTrim -Verbose
					Write-Ok "TRIM completado."
				}
				"HDD" {
					Write-Info "HDD detectado. Desfragmentando..."
					Optimize-Volume -DriveLetter C -Defrag -Verbose
					Write-Ok "Desfragmentación completada."
				}
				default {
					Write-Warn "Tipo de disco no determinado ($type). Ejecutando optimización genérica..."
					Optimize-Volume -DriveLetter C -Verbose
				}
    }
    Read-Host "`nPresiona Enter para cerrar"
        }
        2 {
            Write-Host "Ejecutando sfc /scannow para corregir errores en el sistema..."
            sfc /scannow
        }
		3 {
            Write-Info "Paso 1/3 — CheckHealth..."
		    DISM /Online /Cleanup-Image /CheckHealth
		
		    Write-Info "Paso 2/3 — ScanHealth..."
		    DISM /Online /Cleanup-Image /ScanHealth
		
		    Write-Info "Paso 3/3 — RestoreHealth..."
		    DISM /Online /Cleanup-Image /RestoreHealth
        }
        4 {
            Write-Host "Saliendo del programa."
        }
        default {
            Write-Host "Opción no válida. Por favor, selecciona una opción válida."
			cls
        }
    }
} while ($opcion -ne "4")
