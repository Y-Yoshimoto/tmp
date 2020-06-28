# M365 content delivery Server Setup
## https://docs.microsoft.com/ja-jp/deployoffice/overview-office-deployment-tool
## https://docs.microsoft.com/ja-jp/deployoffice/office-deployment-tool-configuration-options

$Hostname=hostname
$ContentDirectory = "C:\M365ContentDelivery"

##Get officedeploymenttool.
function Get-officedeploymenttool(){ 
    ## Please check the latest download location.
    ### https://go.microsoft.com/fwlink/p/?LinkID=626065
    Invoke-WebRequest 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12827-20268.exe' -OutFile ./officedeploymenttool.exe
    New-Item $ContentDirectory -ItemType Directory
    New-Item $ContentDirectory\Setupfile -ItemType Directory
    Move-Item officedeploymenttool.exe $ContentDirectory\Setupfile\officedeploymenttool.exe
    Start-Process -FilePath $ContentDirectory\Setupfile\officedeploymenttool.exe -Wait
}
# Get M365 SourceData
function Download-Software(){
    # Making configuration
    # To use the configuration file be sure to remove the comments
    $configurationXML = [XML](Get-Content ./configuration-download.xml)
    New-Item $ContentDirectory\SourceData -ItemType Directory
    $configurationXML.Configuration.Add.SourcePath = "$ContentDirectory\SourceData"
    $configurationXML.Save("$ContentDirectory\Setupfile\configuration-download.xml")
    # Download SourceData
    $setupEXE="$ContentDirectory\Setupfile\setup.exe"
    $downloadconfig="$ContentDirectory\Setupfile\configuration-download.xml"
    Start-Process -FilePath $setupEXE -ArgumentList "/download $downloadconfig" -Wait
    Copy-Item ./configuration-shared.xml $ContentDirectory\Setupfile\configuration-shared.xml
}

# Setup-Shaerd SourceData by SMB
function Shaerd-SMB {
    New-SmbShare -Name "M365-SourceData" -Path "$ContentDirectory\SourceData" -FullAccess "Everyone" 
    Get-SmbShare -Name "M365-SourceData" | Format-List -Property * 
}

# Setup-Shaerd SourceData by IIS(http)
function Shaerd-IIS {
    # If Not IIS
      # Install-WindowsFeature Web-Server -IncludeManagementTools 
      # Invoke-WebRequest http://localhost 
    # Add Web-DAV
    Install-WindowsFeature Web-DAV-Publishing 
    Restart-Service W3SVC 
    Get-Website 
    Invoke-WebRequest http://localhost 

    $Site="Default Web Site"
    $VirtualDirectoryName="M365ContentDelivery"
    $LocationPath="$Site/$VirtualDirectoryNam"
    New-WebVirtualDirectory -Site "Default Web Site" -Name "M365ContentDelivery" -PhysicalPath "$ContentDirectory\SourceData" 
    Get-WebVirtualDirectory -Site "Default Web Site" 
    ## enabled directoryBrowse
    Set-WebConfigurationProperty -Filter '/system.webServer/directoryBrowse' -Location $LocationPath -Name enabled -Value True 

    # Add MIME Type 
    Add-WebConfiguration -Location $LocationPath -Filter '/system.webServer/staticContent' -Value @{fileExtension='.bat'; mimeType='application/octet-stream'}
    Add-WebConfiguration -Location $LocationPath -Filter '/system.webServer/staticContent' -Value @{fileExtension='.dat'; mimeType='application/octet-stream'}
    Restart-Service W3SVC 
}

function Set-Installer {
    $InstallerPath = "$ContentDirectory\SourceData\Installer"
    New-Item $InstallerPath -ItemType Directory
    # Making configuration
    $configurationXML = [XML](Get-Content ./configuration-install.xml)
    $configurationXML.Configuration.Add.SourcePath = "http://$Hostname/M365ContentDelivery/"
    $configurationXML.Save("$InstallerPath\configuration-install.xml")
    # Copy Installer and Make Install Bat
    Copy-Item $ContentDirectory\Setupfile\setup.exe $InstallerPath\setup.exe
    $InstallM365Bat=@"
cd /d %~dp0
rem Instal M365 bat
copy \\$Hostname\M365-SourceData\Installer\setup.exe setup.exe
copy \\$Hostname\M365-SourceData\Installer\configuration-install.xml configuration-install.xml
echo Install from $Hostname
setup.exe /configure configuration-install.xml
"@
    Write-Output $InstallM365Bat | Set-Content $InstallerPath\InstallM365.bat -Encoding Default 
}

# main()
# Get-officedeploymenttool
# Download-Software 
# Shaerd-SMB
# Shaerd-IIS
Set-Installer
