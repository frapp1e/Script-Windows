# Ruta donde se guardarán los informes (en el USB)
$usbPath = "D:\Auditoria" # Asegúrate de cambiar la letra de unidad si es diferente

# Crear carpeta si no existe
if (!(Test-Path $usbPath)) {
    New-Item -ItemType Directory -Path $usbPath
}

# Obtener información del PC
$pcInfo = [PSCustomObject]@{
    "Nombre del PC" = $env:COMPUTERNAME
    "Usuario actual" = $env:USERNAME
    "Número de serie" = (Get-WmiObject Win32_BIOS).SerialNumber
    "Versión de Windows" = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
    "Clave de producto" = (Get-WmiObject -Query "SELECT * FROM SoftwareLicensingService").OA3xOriginalProductKey
    "Antivirus instalado" = (Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct).displayName
}

# Obtener aplicaciones instaladas
$installedApps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

# Guardar la información en archivos CSV dentro del USB
$pcInfo | Export-Csv -Path "$usbPath\PC_$env:COMPUTERNAME.csv" -NoTypeInformation
$installedApps | Export-Csv -Path "$usbPath\Apps_$env:COMPUTERNAME.csv" -NoTypeInformation

Write-Host "Auditoría completada en $env:COMPUTERNAME"
Pause
