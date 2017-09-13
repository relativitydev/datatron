<#
.SYNOPSIS
This script is used to install Relativity Data Grid to a server or "node", refered to as a "install run". 

.DESCRIPTION

DataTron - the Relativity Data Grid PowerShell installation script
Data Tron is a PowerShell script that installs Relativity Data Grid on remote servers.
The DataTron PowerShell script is public open source and constantly evolving. 
GetHub Download link for DataTron PowerShell: DataTron PowerShell download
The download is only the PowerShell script used to install Relativity Data Grid.  
The DataTron package itself is available from kCura Client Services.  You must be kCura client with a valid Relativity Data Grid license to obtain the DataTron package which includes Relativity Data Grid.

Definitions:
Node:  A machine that will run elastic search and will be part of the production cluster or the monitoring cluster.  The node must have PowerShell installed.
Command Center: The machine from which this script is run.  It must have PowerShell installed.
Configuration Run:  A run of the script to create a Config.psd1 file to be used by as Install Run.
Install run:  A run of the script with intent to install Relativity Data Grid to a node.
Shield Web Server:  The Relativity web server which the production cluster use for shield authentication.

Create the Command Center.
1.) Unzip the DataTron Folder provided by kCura Client Support on a root drive of the Command Center.
2.) Unzipped the kibana-4.5.4-windows folder into the newly created DataTron folder.  This package can be downloaded here:  Kibana Download
3.) Copy the certificate used by the Shield web server it must be in the form of a .cer file into the elasticsearch-main folder in the RelativityDataGrid folder in the DataTron folder.
4.) Add a valid JDK 8 installer into the elasticsearch-main folder in the RelativityDataGrid folder in the DataTron folder.
5.) Check the execution policy for the Command Center using, Get-ExecutionPolicy.  If the execution policy is restricted it must be changed to remote signed using.  Set-ExecutionPolicy RemoteSigned.
Do a configuration Run.
The configuration run is kicked off by opening PowerShell as an administration, navigating to the DataTron folder and running the following command:
.\Run-DataTron6.0.ps1 -Config
The configuration requires the following information:
> The service account username and password.
> A name for the Production node.
> A name for the monitoring node (optional: enter blank to skip).
> The names of all nodes that will be in the production array this will be Master(s), Data(s), and Client(s).
> You will specify the minimum numbers of masters.  Should be an odd number.  https://www.elastic.co/guide/en/elasticsearch/reference/2.3/modules-node.html#split-brain
> A Data path must be added for each type of node.  For example, c:\data, f:\DataGrid, g:\relativitydatagrid\data, etc.  This is a local drive.
> The name of all Primary and Distributed SQL servers in the Relativity Environment.  This is a comma separated list.  Do not include Invariant.
> The Shield Web Server (see above definitions).  This must be the name that will correspond with the name on the certificate added during creation of the Command Center.
Do installation Runs.
A good order of operations to do the install runs in is as follows:
Production cluster Master node(s).
Monitoring cluster Monitoring node.
Production cluster Data node(s).
Production cluster Client node(s).

The longest sections of the script are the Install of Java and the copying of folders.  If the script needs to be re-run due so errors there are switches to stop reinstall of java or recopying of the folders.
You can use one or both switches if needed.
In the config folder in the RelativityDataGrid folder there is a resetyml.ps1 that will reset the elasticsearch.yml back to default if needed.

.NOTES

The longest sections of the script are the Install of Java and the copying of folders.  If the script needs to be re-run due so errors there are switches to stop reinstall of java or recopying of the folders.
You can use one or both switches if needed.
In the config folder in the RelativityDataGrid folder there is a resetyml.ps1 that will reset the elasticsearch.yml back to default if needed.

.PARAMETER DriveLetter
The drive letter to host the Relativity Data Grid folder and from which the Elasticsearch service will run.  This must be a single character.  Don't use a colon.

This is a mandatory parameter during a installation run.

.PARAMETER MachineName
The name of the server where Relativity Data Grid will be installed.

.PARAMETER IsMaster
Use this parameter to create a master node for the production cluster.

.PARAMETER IsClient
Use this parameter to create a client node for the production cluster.

.PARAMETER IsData
Use this parameter to create a data node for the production cluster.

.PARAMETER IsMonitor
Use this parameter to create a monitoring node for the monitoring cluster.

.PARAMETER dontCopyFolders
Specify this switch to skip copying of the Relativity Data Grid folder.

.PARAMETER dontInstalljava
Spdcify this switch to skip java installation.

.PARAMETER Config
Use this switch to create a config file for an install run.

.EXAMPLE
.\DataTron\Run-DataTron.ps1 -Config

This will create a Config.psd1 file in the directory for and install run.
This is a switch and cannot be run with any other parameters.
Once a Config.psd1 file is created the script can be used to do an install run.

.EXAMPLE
.\DataTron\Run-DataTron.ps1 -driveLetter c -machineName nodename -IsMaster

 The above will install DataGrid to the drive letter c on the machine named nodename and will make the node a monitoring node for the production cluster.  It is not a member of the production cluster.

.EXAMPLE
.\DataTron\Run-DataTron.ps1 -driveLetter g -machineName nodename2 -IsMonitor

 The above will install DataGrid to the drive letter g on the machine named nodename2 and will make the node a production master node.

.EXAMPLE
.\DataTron\Run-DataTron.ps1 -driveLetter c -machineName nodename3 -IsData

The above will install DataGrid to the drive letter c on the machine named nodename3 and will make the node a production data node.

.EXAMPLE
.\DataTron\Run-DataTron.ps1 -driveLetter c -machineName nodename3 -IsClient
The above will install DataGrid to the drive letter c on the machine named nodename3 and will make the node a production client node.

.EXAMPLE
.\DataTron\Run-DataTron.ps1 -driveLetter c -machineName someserver -IsMaster -dontInstallJava -dontCopyfolders

Does an install run but does not install Java and does not copy the installation folders. Both switches can be used or either one singly.

#>
[CmdletBinding(DefaultParameterSetName='Install')]
param(
[Parameter(Mandatory=$true, ParameterSetName = 'Install')]
[char]$driveLetter,

[Parameter(Mandatory=$true, ParameterSetName = 'Install')]
[string[]]$machineName,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$IsMaster,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$IsClient,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$IsData,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$IsMonitor,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$dontCopyFolders,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$dontInstalljava,

[Parameter(Mandatory=$true, ParameterSetName = 'Config')]
[switch]$Config
)
If($PSVersionTable.PSVersion.Major -lt 4){
Write-Host "The PowerShell verison is $PSVersionTable.PSVersion.`nVersion 4.0 or higher required."
Break
}

function LogonLocal {
Invoke-Command -ComputerName $array -ScriptBlock {
$UserName = $Using:UserName
$separator = "\"
$split = $UserName.Split($separator, [System.StringSplitOptions]::RemoveEmptyEntries)
$accountToAdd = $split[1]

$sidstr = $null
try {
	$ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
	$sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
	$sidstr = $sid.Value.ToString()
} catch {
	$sidstr = $null
}

Write-Verbose "Account: $($accountToAdd)"
Write-Verbose "Account SID: $($sidstr)"

$tmp = [System.IO.Path]::GetTempFileName()

Write-Verbose "Export current Local Security Policy"

function exportSec{
    secedit.exe /export /cfg "$($tmp)" 
}
exportSec | Out-Null

$c = Get-Content -Path $tmp 

$currentSetting = ""

foreach($s in $c) {
	if( $s -like "SeServiceLogonRight*") {
		$x = $s.split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
		$currentSetting = $x[1].Trim()

	}
}

if( $currentSetting -notlike "*$($sidstr)*" ) {
	Write-Host "Modify Setting ""Logon as a Service""" -ForegroundColor DarkCyan
	
	if( [string]::IsNullOrEmpty($currentSetting) ) {
		$currentSetting = "*$($sidstr)"
	} else {
		$currentSetting = "*$($sidstr),$($currentSetting)"
	}
	
	
	$outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeServiceLogonRight = $($currentSetting)
"@

	$tmp2 = [System.IO.Path]::GetTempFileName()
	
	
	Write-Host "Import new settings to Local Security Policy" -ForegroundColor DarkCyan
	$outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force

	Push-Location (Split-Path $tmp2)
	
	try {
		function Import {secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS}
        Import | Out-Null
	} finally {	
		Pop-Location
	}
} else {
	Write-Host "NO ACTIONS REQUIRED! Account already in ""Logon as a Service""" -ForegroundColor DarkCyan
}

Write-Host "Done." -ForegroundColor DarkCyan

}}

function TestPSRemoting {
    #Test the PSRemoting
    Try{
        Invoke-Command -ComputerName $array {} -ErrorAction Stop
    }
    Catch [System.Management.Automation.Remoting.PSRemotingTransportException]{
        $ErrorMessage = $_.Exception.Message
        Write-Host "PowerShell cannot connect to the Windows Remoting service on $array.`n" -ForegroundColor Yellow;
        Write-Output "Here are the Trusted Hosts listed for this machine.  The output will be blank if no Trusted Hosts exist.`n"
        Write-Host "Found the following TrustedHosts: " (Get-Item WSMan:\localhost\Client\TrustedHosts).Value -ForegroundColor Green;
        Write-Host "`nThe computer will be added to the Trusted Host list now if it is missing.`n" -ForegroundColor Green;

        $A = Get-Item wsman:\localhost\Client\TrustedHosts | Select Value -ExpandProperty Value
        If($A){
            $A = $A + ",$array"
        }
        IF(!$A){
            $A = $array
        }
        set-item wsman:\localhost\Client\TrustedHosts -value "$A" -Force
        sleep -s 5
        
        Write-Host (Get-Item WSMan:\localhost\Client\TrustedHosts).Value "is now added to TrustedHosts the installation will continue.`n" -ForegroundColor Green;
    }
}

if($Config){
clear
##Get Datatron Data from the User

##Create the psd1 file
Try{
New-Item .\Config.psd1 -type file -Force | Out-Null
}
Catch [System.IO.IOException]{
        $ErrorMessage = $_.Exception.Message
        $ErrorName = $_.Exception.GetType().FullName
        Write-Host "Could not write the Config file to the DataTron Folder.`n" -ForegroundColor Red;
        Write-Output "The Exeception Message is:`n $ErrorMessage.`n"
        Write-Output "The Exeception Name is:`n $ErrorName.`n"
        Exit
}

##Prep the file
"@{" | Out-File .\Config.psd1


Write-Host "Welcome to DataTron config mode.`n" -ForegroundColor Green
Write-Host "We need some input to create a configuration folder to install Relativity Data Grid`n" -ForegroundColor Green
Start-Sleep -s 1


##Get Username
    Write-Host "Enter the Relativity User Account.  Use domain\username format, for workgroup use .\username format." -ForegroundColor Cyan
    $UserName = Read-Host ">>>"
    "`t`tUserName = " + """$UserName"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1
    
##Get Password
    Do{
        Write-Host "Enter the Relativity User Account Password`n" -ForegroundColor Cyan
        Read-Host "<<Enter Password>>" -AsSecureString | Set-Variable -Name readPass
        Write-Host "Re-enter the Relativity User Account Password`n" -ForegroundColor Cyan
        Read-Host "<<Enter Password>>" -AsSecureString | Set-Variable -Name readPass2
        $readPass_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($readPass))
        $readPass2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($readPass2))
        If ($readPass_text -ne $readPass2_text){
            $passMatch = $false
            Write-Host "The password does not match" -ForegroundColor Yellow
        }
        If ($readPass_text -eq $readPass2_text){
            $passMatch = $true
        } 
    }Until ($passMatch)
    $readPass | ConvertFrom-SecureString | Set-Variable -Name readPass
    "`t`treadPass = " + """$readPass"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1
    
##Get Monitoring Node Name
    Write-Host "Enter the Name of the Monitoring Node. Press enter to skip adding a monitoring Node.`n" -ForegroundColor Cyan;
    $MonitoringNodeName = Read-Host ">>>"
    if($MonitoringNodeName -ne ""){
        Do{ $array = $MonitoringNodeName
            $ping = ""
                if (Test-Connection -ComputerName $array -Quiet -Count 1){
                    Write-Host "The connection to $array was successful.`n" -ForegroundColor Green;
                    $ping = "success"
                    TestPSRemoting
                    LogonLocal 
                    "`t`tMonitoringNodeName = " + """$MonitoringNodeName"";" | Add-Content .\Config.psd1
                    Start-Sleep -s 1        
                }else{
                    Write-Host "Could not ping the $MonitoringNodeName`n" -ForegroundColor Yellow
                    Write-Host "Enter the Name of the Monitoring node or press enter to skip" -ForegroundColor Cyan
                    $MonitoringNodeName = Read-Host ">>>"
                    if($MonitoringNodeName -eq ""){
                        $ping = "success"
                    }
            }
        } Until ($ping -eq "success")
    }
##Get Production Array

    $stackVar = "`"" + "[" + "`"" + "`""
   Do{ 
       Write-Host "Enter the name of each server in the production cluster.`nIf you are done adding servers type exit" -ForegroundColor Cyan
       $array = Read-Host ">>>"
       if($array -eq "exit"){
           $q = "exit"
           "`t`tProductionHostsArray = " + $stackVar.Substring(0,$stackVar.Length-3) + "]" + "`";" | Add-Content .\Config.psd1
           }
           if($array -ne "exit"){
                   Write-Output "You entered: $array`n"
                   Write-Output "Checking the connection to $array.`n"
           
               $ping = ""

               if (Test-Connection -ComputerName $array -Quiet -Count 1){
                   Write-Host "The connection to $array was successful." -ForegroundColor Green;
                   $ping = "success"

                   Try{
                   Invoke-Command -ComputerName $array {} -ErrorAction Stop
                   }Catch [System.Management.Automation.Remoting.PSRemotingTransportException]{
                   Write-Verbose "Starting ps remote test"
                   TestPSREmoting
                   Write-Verbose "Ending test"
                   }Finally{
                   LogonLocal
                   }
               }else{
                   Write-Host "The connection to $array was not succssesfull.  You can try $array again or enter a new server name.`n" -ForegroundColor Red;
               }
               if($ping -eq "success"){
                   $stackVar += $array + "`"" + "`"" + "," + "`"" + "`""
               }
               if($ping -eq ""){
                   Clear-Variable array
               }
           }
       }Until($q -eq "exit")
Start-Sleep -s 1

##Get the produciton cluster name
    Write-Host "Enter the Name of the Production Cluster`n" -ForegroundColor Cyan
    $Clustername = Read-Host ">>>"
    "`t`tClustername = " + """$Clustername"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the monitoring cluster name
    Write-Host "Enter the Name of the Monitoring Cluster`n" -ForegroundColor Cyan
    $ClusternameMON = Read-Host ">>>"
    "`t`tClusternameMON = " + """$ClusternameMON"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get minimum number of master nodes
    Write-Host "Enter minimum number of master nodes for the production cluster`n" -ForegroundColor Cyan
    $MinimumMasterNode = Read-Host ">>>"
    "`t`tMinimumMasterNode = " + "$MinimumMasterNode;" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the data path for the master node
    Write-Host "Enter data path for the master node.  For example c:\data`n" -ForegroundColor Cyan
    $PathDataMaster = Read-Host ">>>"
    "`t`tPathDataMaster = " + """$PathDataMaster"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the data path for the client node(s)
    Write-Host "Enter data path for the client node(s).  For example c:\data`n" -ForegroundColor Cyan
    $PathDataClient = Read-Host ">>>"
    "`t`tPathDataClient = " + """$PathDataClient"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the data path for the data node(s)
    Write-Host "Enter data path for the data node(s).  For example c:\data`n" -ForegroundColor Cyan
    $PathDataData = Read-Host ">>>"
    "`t`tPathDataData = " + """$PathDataData"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the data path for the monitoring node(s)
    Write-Host "Enter data path for the monitoring node(s).  For example c:\data`n" -ForegroundColor Cyan
    $PathDataMonitor = Read-Host ">>>"
    "`t`tPathDataMonitor = " + """$PathDataMonitor"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the name of the SQL server(s)
    Write-Host "Enter names of the SQL servers(s).  This is a comma separated list of Primary and Distributed SQL servers excluding Invariant.`n" -ForegroundColor Cyan
    $SQLServers = Read-Host ">>>"
    "`t`tSQLServers = " + """$SQLServers"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the name of the web server for shield authentication
    Write-Host "Enter names of the web server for shield authentication`n" -ForegroundColor Cyan
    $webServer = Read-Host ">>>"
    $bytes = ""
    
    $webRequest = [Net.WebRequest]::Create("https://$webServer/")
    Try { 
        $webRequest.GetResponse()
    }
    Catch {}
   
    $cert = $webRequest.ServicePoint.Certificate

    Try{
    $bytes = $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)
    }
    Catch [System.Management.Automation.RuntimeException]{
        Write-Host "An Execption has occurred. The web server could not be reached.`n" -BackgroundColor Green -ForegroundColor Black;
    }
    Try{
        set-content -value $bytes -encoding byte -path ".\RelativityDataGrid\cert.cer" -ErrorAction Stop
    }
    Catch [System.Management.Automation.RuntimeException]{
        Write-Host "The script will continue but the certificate was not export to the RelativityDataGrid Folder.`n" -ForegroundColor Yellow;
        Remove-item .\RelativityDataGrid\cert.cer
    }
    "`t`twebServer = " + """$webServer"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Get the backup path location
    Write-Host "Enter the backup path location`nThis must be an accessible path to the service account." -ForegroundColor Cyan
    $ping = ""
    Do{$PathRepoWindows = Read-Host ">>>" 
        If ($PathRepoWindows){
            if(![System.IO.Directory]::Exists($PathRepoWindows)){
            Write-Host "The share location cannot be reached.  Please re-enter the backup location or press enter to skip" -ForegroundColor Yellow
            }
            if([System.IO.Directory]::Exists($PathRepoWindows)){
            $ping = "success"
            $PathRepo = ($PathRepoWindows -replace "\\", "\\")
            "`t`tPathRepo = " + "`"" + "[" + "`"" + """$PathRepo""" + "`"" +"]" + "`";" | Add-Content .\Config.psd1
            Start-Sleep -s 1
`            }
        }
        If ($PathRepoWindows -eq ""){
            $ping = "success"
        } 
    } Until($ping -eq "success")

##Create a new for the shield useraccount
    Write-Host "Enter name for the esadmin account`n" -ForegroundColor Cyan
    $esUsername = Read-Host ">>>"
    "`t`tesUsername = " + """$esUsername"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

##Create a new for the shield useraccount passoword
    Do{
        Write-Host "Enter the Shield User Account Password`n" -ForegroundColor Cyan
        Read-Host "<<Enter Password>>" -AsSecureString | Set-Variable -Name readPass
        Write-Host "Re-enter the Shield User Account Password`n" -ForegroundColor Cyan
        Read-Host "<<Enter Password>>" -AsSecureString | Set-Variable -Name readPass2
        $readPass_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($readPass))
        $readPass2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($readPass2))
        If ($readPass_text -ne $readPass2_text){
            $passMatch = $false
            Write-Host "The password does not match" -ForegroundColor Yellow
        }
        If ($readPass_text -eq $readPass2_text){
            $passMatch = $true
        } 
    }Until ($passMatch)
    $readPass | ConvertFrom-SecureString | Set-Variable -Name readESPass
    "`t`treadESPass = " + """$readESPass"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1

"`t`tSecondsToWait = 1;" | Add-Content .\Config.psd1
"}" | Add-Content .\Config.psd1
cls
Write-Host "The configuration is completed. Here is the configuration file created by this setup.`n" -ForegroundColor Green
Get-Content .\Config.psd1
}

#Installation run
else{

    #Import Variables from the psd1 file in the same directory as this script.
    Set-Location -Path (Get-Location).Drive.Root
    $currentScriptDir = ".\DataTron"
    Import-LocalizedData -BaseDirectory $currentScriptDir -FileName Config.psd1 -BindingVariable Data


    #Variables for "Update the servicename"
    [string]$UserName = $Data.UserName
    [string]$readPass = $Data.readPass
    [int]$SecondsToWait = $Data.SecondsToWait
    #Variables for "Update YML"
    [String]$MonitoringNodeName = $Data.MonitoringNodeName
    [String[]]$ProductionHostsArray = $Data.ProductionHostsArray
    [String]$Clustername = $Data.Clustername
    [String]$ClusternameMON = $Data.ClusternameMON
    [String]$MinimumMasterNode = $Data.MinimumMasterNode
    [String]$PathDataMaster = $Data.PathDataMaster
    [String]$PathDataClient = $Data.PathDataClient
    [String]$PathDataData = $Data.PathDataData
    [String]$PathDataMonitor = $Data.PathDataMonitor
    [String]$SQLServers = $Data.SQLServers
    [String]$WebServer = $Data.WebServer
    [String]$PathRepo = $Data.PathRepo
    #Variables for shield
    [string]$esUsername = $Data.esUsername
    [string]$readESPass = $Data.readESPass

    #Convert $readPass to clear text
    $readPass| ConvertTo-SecureString | Set-Variable -Name passSecString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passSecString)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    $readESPass| ConvertTo-SecureString | Set-Variable -Name passSecString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passSecString)
    $esPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)


    ##Test the network connection to the target passed.
    Write-Output "Checking the connection to $machineName.`n"
    if (Test-Connection -ComputerName $machineName -Quiet -Count 1){
    }else{
        Write-Host "The connection to $machineName was not succssesfull would you like to try to ping the server?`n" -ForegroundColor Yellow
        $ping = Read-Host "Press enter to not ping $machineName and stop the script.`nType yes to ping $machineName.`n"

    If($ping -eq "yes"){
        Test-Connection -ComputerName $machineName
    }

    #Land back in DataTron Folder.
    Set-Location .\DataTron
    break}

    Write-Host "Connection to $machineName successful.`n" -ForegroundColor Green

    #Test the drive letter passed.
    Write-Verbose "Testing the drive letter passed in arguement -driveLetter"
    $driveLetterString = $driveLetter.ToString()
    $fullDrive = $driveLetterString.ToUpper() + ":"
    
    $getDrive = (Get-WmiObject Win32_LogicalDisk -computer $machineName | select name -ExpandProperty name).Contains($fullDrive)
    if($getDrive){
        Write-Verbose "Drive letter $driveLetter found, continuing"
    }else{
        Write-Host "The drive $driveLetter was not found.  Check the drive letter on $machineName." -ForegroundColor Red
        exit
    }

    #Begin The installer.

    Foreach($target in $machineName){ 
    Write-Output "Begin Data Tron:`n"

    ##Copy the Data Grid Package
    
        Write-Verbose "Start copying Relativity folders"

        If($dontCopyFolders -eq $false){

            Write-Output "Begin Copy Folders to $target"

            $installPath = "\\" + $target + "\$driveLetter`$\"

            # Copies the package to the remote server, the package must be in the DataTron Folder.
            Set-Location -Path (Get-Location).Drive.Root
            Copy-Item .\DataTron\RelativityDataGrid -Destination $InstallPath -Recurse -force

            Write-Output "Finished copying folders to $target."
        }
        #end

    #Install Java Silently.

        #start
        IF((Test-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*") -eq $false){

            If($dontInstalljava -eq $false){

                Write-Output "Begin installation of Java on $target.`nExpect a long delay as Java installs."

                    Invoke-Command $target -ScriptBlock {
                        $vers = "$Using:driveLetter`:\RelativityDataGrid\jdk-8*"
                        $version = Get-ChildItem $vers | Select-Object Name -First 1 -ExpandProperty Name
                        $filePath = "$Using:driveLetter`:\RelativityDataGrid\$version"
                        $jLog = "$Using:driveLetter`:\javainstallog.txt"
                        $jLoc = "/s INSTALLDIR=""$Using:driveLetter`:\Program Files\Java\jdk8"""
                        $proc = Start-Process -FilePath $filePath -ArgumentList $jLoc -Wait -PassThru -RedirectStandardOutput $jLog
                        $proc.WaitForExit()
                    } 
        
                Write-Output "End installation of Java on $target."
            }
        }else{

            $javaPath = (Get-ChildItem "\\dg-ramp-01\c`$\Program Files\Java\jdk*").Name
            Write-Host "Java is installed here: $javaPath.`n" -ForegroundColor Green;

        }
        if((Resolve-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*") -eq $false){
            Write-Host "Java failed to install on $target." 
            Exit
        }
        #end

    ##Create environmental variables on the node.

        #start

        Write-Verbose "Begin setting the environmental variable for Java on $target.`n"

        if(Resolve-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*"){  
                Invoke-Command $target -ScriptBlock {
                    $driveLetter = $Using:driveLetter
                    $version = (Get-ChildItem "$driveLetter`:\Program Files\Java\jdk*").Name
                    $filePath = "$driveLetter`:\Program Files\Java\$version"
                    Write-Verbose "$filePath Is the file path"
                    [System.Environment]::SetEnvironmentVariable("KCURA_JAVA_HOME",$filePath,"User")
                    [System.Environment]::SetEnvironmentVariable("KCURA_JAVA_HOME",$filePath,"Machine")
                    $sysEnvMachine = [System.Environment]::GetEnvironmentVariable("KCURA_JAVA_HOME","Machine")
                    $sysEnvUser = [System.Environment]::GetEnvironmentVariable("KCURA_JAVA_HOME","User")
                    Write-Verbose "The KCURA_JAVA_HOME system environmental variable was set to: $sysEnvMachine"
                    Write-Verbose "The KCURA_JAVA_HOME user environmental variable was set to: $sysEnvUser"
                    $envArgs = "KCURA_JAVA_HOME $filePath /m"
                    & setx "KCURA_JAVA_HOME" $filePath "/m" | Out-Null
                }
        }else{
            Write-Host "Java is not installed on $target.`n" -ForegroundColor Red;

            Write-Host "If you are using the -dontInstallJava switch try the script again without that switch.`n"
            Exit
        }
    

        Write-Verbose "End setting the environmental variable for Java on $target.`n"

        #end


    ##Install the certs into Windows and Java

        #start

        Write-Verbose "Begin adding certificates to Windows and Java to $target.`n"

        Invoke-Command $target -ScriptBlock {
            #Windows

            $certdir = "$Using:driveLetter`:\RelativityDataGrid\*.cer"
            $certname = Get-ChildItem -Path $certdir | Select-Object name -ExpandProperty Name 
            Import-Certificate -FilePath "$Using:driveLetter`:\RelativityDataGrid\$certname" -CertStoreLocation Cert:\LocalMachine\Root | Out-Null
            Write-Verbose "Done importing certificate."

            #Java
            $installedVersion =  (Get-ChildItem "$Using:driveLetter`:\Program Files\Java\jdk*").Name
            $keyTool = "$Using:driveLetter`:\Program Files\Java\$installedVersion\bin\keytool.exe"
            $keystore = "$Using:driveLetter`:\Program Files\Java\$installedVersion\jre\lib\security\cacerts"
            $list = "-importcert","-noprompt","-alias","shield","-keystore","""$keystore""","-storepass","changeit","-file","""$Using:driveLetter`:\RelativityDataGrid\$certname"""
            Set-Location -Path (Get-Location).Drive.Root 
            Set-Location "$Using:driveLetter`:\Program Files\Java\$installedVersion\bin"
            & .\keytool.exe $list 2>&1 | %{ "$_" } | Out-Null
            Write-Verbose "Done with import from keytool."
        }


        Write-Verbose "End adding certificates to Windows and Java to $target."

        #end

    ##Update the YML file

        #start

        If($IsMaster){
        $nodeType = "Master"
        }elseif($IsClient){
        $nodeType = "Client"
        }elseif($IsData){
        $nodeType = "Data"
        }elseif($IsMonitor){
        $nodeType = "Monitor"
        }

        Write-Verbose "Updating the elasticsearch YML on $target the selected role is $nodeType."

        foreach($target in $machineName){

        Invoke-Command -ComputerName $target -ScriptBlock {
        $Clustername = $Using:Clustername
        $ClusternameMON = $Using:ClusternameMON
        $NodeName = $Using:machineName
        $MinimumMasterNode = $Using:MinimumMasterNode
        $ProductionHostsArray = $Using:ProductionHostsArray
        $MonitoringNodeName = $Using:MonitoringNodeName
        $PathDataMaster = $Using:PathDataMaster
        $PathDataClient = $Using:PathDataClient
        $PathDataData = $Using:PathDataData
        $PathDataMonitor = $Using:PathDataMonitor
        $SQLServers = $Using:SQLServers
        $WebServer = $Using:WebServer
        $PathRepo = $Using:PathRepo
        $esUsername = $Using:esUsername
        $esPassword = $Using:esPassword
 
                if ($Using:IsMaster){  
 
                    # Update the clustername
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("cluster.name: <<clustername>>", "cluster.name: " + $Clustername)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the node name
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.name: <<nodename>>", "node.name: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update discovery.zen.minimum_master_nodes
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.minimum_master_nodes: 1", "discovery.zen.minimum_master_nodes: " + $MinimumMasterNode)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update discovery.zen.ping.unicast.hosts
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.ping.unicast.hosts: [""<<host1>>"",""<<host2:port>>""]", "discovery.zen.ping.unicast.hosts: " + $ProductionHostsArray)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                    if($MonitoringNodeName){
                    #Update the marvel setting
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "host: [""http://" + $MonitoringNodeName + ":9200""]")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                    }else{
                        #Remove the marvel setting
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("marvel.agent.exporters:", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("id1:", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("type: http", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                        try{
                            Write-Host "No monitoring cluster specified marvel plugin folder has already been removed.`n" -BackgroundColor Green -ForegroundColor Black;
                            Remove-Item -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\plugins\marvel-agent" -Recurse -ErrorAction Stop
                        }
                        catch [System.Management.Automation.ItemNotFoundException]{
                            $ErrorMessage = $_.Exception.Message
                            $ErrorName = $_.Exception.GetType().FullName
                            Write-Host "Marvel Plugin folder has already been removed.`n" -BackgroundColor Green -ForegroundColor Black;
                            Write-Output "The Exeception Message is:`n $ErrorMessage.`n"    
                            Write-Output "The Exeception Name is:`n $ErrorName.`n"
                        }
                    }

                    #Update the path data
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("path.data: C:\RelativityDataGrid\data", "path.data: " + $PathDataMaster)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii


                    # Update the network host
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("network.host: 0.0.0.0", "network.host: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # SQL server white list
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("#sqlserver_whitelist: <<comma delimited sql servers >>", "sqlserver_whitelist: " + $SQLServers)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the kCuraBearerRealm
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("publicJWKsUrl: https://<<server>>/Relativity/Identity/.well-known/jwks", "publicJWKsUrl: https://" + $WebServer + "/Relativity/Identity/.well-known/jwks")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the value for node.date
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.data: true", "node.data: false")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                    if($PathRepo -ne "[""""]"){
                        # Update the repo path $PathRepo
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("#path.repo: [""\\\\MY_SERVER\\Snapshots""]", "path.repo: " + " $PathRepo")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
                    }


                }
 
                elseif ($Using:IsClient) {
 
                    # Update the clustername
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("cluster.name: <<clustername>>", "cluster.name: " + $Clustername)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the node name
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.name: <<nodename>>", "node.name: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update discovery.zen.minimum_master_nodes
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.minimum_master_nodes: 1", "discovery.zen.minimum_master_nodes: " + $MinimumMasterNode)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                    # Update discovery.zen.ping.unicast.hosts
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.ping.unicast.hosts: [""<<host1>>"",""<<host2:port>>""]", "discovery.zen.ping.unicast.hosts: " + $ProductionHostsArray)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                    if($MonitoringNodeName){
                    #Update the marvel setting
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "host: [""http://" + $MonitoringNodeName + ":9200""]")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
                    }else{
                        #Remove the marvel setting
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("marvel.agent.exporters:", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("id1:", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("type: http", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                        try{
                            Write-Host "No monitoring cluster specified marvel plugin folder has already been removed.`n" -BackgroundColor Green -ForegroundColor Black;
                            Remove-Item -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\plugins\marvel-agent" -Recurse -ErrorAction Stop
                        }
                        catch [System.Management.Automation.ItemNotFoundException]{
                            $ErrorMessage = $_.Exception.Message
                            $ErrorName = $_.Exception.GetType().FullName
                            Write-Host "Marvel Plugin folder has already been removed.`n" -BackgroundColor Green -ForegroundColor Black;
                            Write-Output "The Exeception Message is:`n $ErrorMessage.`n"    
                            Write-Output "The Exeception Name is:`n $ErrorName.`n"
                        }
                    }
                    
                    #Update the path data
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("path.data: C:\RelativityDataGrid\data", "path.data: " + $PathDataClient)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the network host
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("network.host: 0.0.0.0", "network.host: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # SQL server white list
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("#sqlserver_whitelist: <<comma delimited sql servers >>", "sqlserver_whitelist: " + $SQLServers)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the kCuraBearerRealm
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("publicJWKsUrl: https://<<server>>/Relativity/Identity/.well-known/jwks", "publicJWKsUrl: https://" + $WebServer + "/Relativity/Identity/.well-known/jwks")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the value for node.data
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.data: true", "node.data: false")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the value for node.master
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.master: true", "node.master: false")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    if($PathRepo -ne "[""""]"){
                        # Update the repo path $PathRepo
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("#path.repo: [""\\\\MY_SERVER\\Snapshots""]", "path.repo: " + " $PathRepo")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
                    }
                }
 
                elseif ($Using:IsData){
                    # Update the clustername
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("cluster.name: <<clustername>>", "cluster.name: " + $Clustername)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                    # Update the node name
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.name: <<nodename>>", "node.name: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update discovery.zen.minimum_master_nodes
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.minimum_master_nodes: 1", "discovery.zen.minimum_master_nodes: " + $MinimumMasterNode)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update discovery.zen.ping.unicast.hosts
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.ping.unicast.hosts: [""<<host1>>"",""<<host2:port>>""]", "discovery.zen.ping.unicast.hosts: " + $ProductionHostsArray)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    if($MonitoringNodeName){
                    #Update the marvel setting
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "host: [""http://" + $MonitoringNodeName + ":9200""]")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
                    }else{
                        #Remove the marvel setting
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("marvel.agent.exporters:", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("id1:", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("type: http", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                        try{
                            Write-Host "No monitoring cluster specified marvel plugin folder has already been removed.`n" -BackgroundColor Green -ForegroundColor Black;
                            Remove-Item -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\plugins\marvel-agent" -Recurse -ErrorAction Stop
                        }
                        catch [System.Management.Automation.ItemNotFoundException]{
                            $ErrorMessage = $_.Exception.Message
                            $ErrorName = $_.Exception.GetType().FullName
                            Write-Host "Marvel Plugin folder has already been removed.`n" -BackgroundColor Green -ForegroundColor Black;
                            Write-Output "The Exeception Message is:`n $ErrorMessage.`n"    
                            Write-Output "The Exeception Name is:`n $ErrorName.`n"
                        }
                    }
 
                    #Update the path data
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("path.data: C:\RelativityDataGrid\data", "path.data: " + $PathDataData)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the network host
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("network.host: 0.0.0.0", "network.host: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # SQL server white list
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("#sqlserver_whitelist: <<comma delimited sql servers >>", "sqlserver_whitelist: " + $SQLServers)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the kCuraBearerRealm
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("publicJWKsUrl: https://<<server>>/Relativity/Identity/.well-known/jwks", "publicJWKsUrl: https://" + $WebServer + "/Relativity/Identity/.well-known/jwks")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the value for node.master
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.master: true", "node.master: false")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    if($PathRepo -ne "[""""]"){
                        # Update the repo path $PathRepo
                        $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                        $result = foreach ($line in $yml) {$line.Replace("#path.repo: [""\\\\MY_SERVER\\Snapshots""]", "path.repo: " + " $PathRepo")}
                        $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
                    }
                }
 
                elseif ($Using:IsMonitor) {
 
                    # Update the clustername
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("cluster.name: <<clustername>>", "cluster.name: " + $ClusternameMON)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the node name
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("node.name: <<nodename>>", "node.name: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update discovery.zen.ping.unicast.hosts
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("discovery.zen.ping.unicast.hosts: [""<<host1>>"",""<<host2:port>>""]", "discovery.zen.ping.unicast.hosts: " + "[""" + $MonitoringNodeName + """]")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    #Update action.destructive_requires_name
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("action.destructive_requires_name: true", "action.destructive_requires_name: false")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    #Update action.auto_create_index
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("action.auto_create_index: false,.security", "action.auto_create_index: true")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    #Update the path data
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("path.data: C:\RelativityDataGrid\data", "path.data: " + $PathDataMonitor)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Update the network host
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("network.host: 0.0.0.0", "network.host: " + $NodeName)}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    # Turn off Shield (only for monitoring nodes)
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("#shield.enabled: false", "shield.enabled: false")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    #Remove the marvel setting
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("marvel.agent.exporters:", "")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("id1:", "")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("type: http", "")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
                    $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                    $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "")}
                    $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii

                        try{
                            Write-Output "This is a monitoring node the marvel plugin folder will be removed.`n"
                            Remove-Item -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\plugins\marvel-agent" -Recurse -ErrorAction Stop
                        }
                        catch [System.Management.Automation.ItemNotFoundException]{
                            $ErrorMessage = $_.Exception.Message
                            $ErrorName = $_.Exception.GetType().FullName
                            Write-Output "Marvel Plugin folder has already been removed.`n"

                            Write-Output "The Exeception Message is:`n $ErrorMessage.`n"    
                            Write-Output "The Exeception Name is:`n $ErrorName.`n"
                        }
                }

            #end script block
            }

        #end foreach loop in Update YML

        }

        Write-Verbose "YML Update Completed."

        #end

    ##Install ElasticSearch service

        #start

        Write-Host "Installing Elasticsearch service on $target.`n" -ForegroundColor Green

        foreach($target in $machineName){
            Invoke-Command -ComputerName $target -ScriptBlock {
                Set-Location -Path (Get-Location).Drive.Root
                Set-Location "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\bin\"
                & .\kservice.bat "install" | Out-Null
            }
        }
        Write-Verbose "Finished installing Elasticsearch service on $target."

        #end


    ##Update the service name and password

        #start

        Invoke-Command $machineName -ScriptBlock {

        $Password = $Using:Password
        $mName = $Using:machineName
        $SecondsToWait =$Using:SecondsToWait
        $UserName = $Using:UserName

        function PowerShell-PrintErrorCodes ($strReturnCode)
        {
        #This function will print the right value. The error code list was extracted using the MSDN documentation for the change method as December 2014
        Switch ($strReturnCode)
            {
            0{ write-host  "    0 The request was accepted." -foregroundcolor "Red" }
            1{ write-host  "    1 The request is not supported." -foregroundcolor "Red" }
            2{ write-host  "    2 The user did not have the necessary access."-foregroundcolor "Red" }
            3{ write-host  "    3 The service cannot be stopped because other services that are running are dependent on it." -foregroundcolor "Red" }
            4{ write-host  "    4 The requested control code is not valid, or it is unacceptable to the service." -foregroundcolor "Red"}
            5{ write-host  "    5 The requested control code cannot be sent to the service because the state of the service (Win32_BaseService State property) is equal to 0, 1, or 2." -foregroundcolor "Red"}
            6{ write-host  "    6 The service has not been started." -foregroundcolor "Red"}
            7{ write-host  "    7 The service did not respond to the start request in a timely fashion." -foregroundcolor "Red"}
            8{ write-host  "    8 Unknown failure when starting the service."-foregroundcolor "Red" }
            9{ write-host  "    9 The directory path to the service executable file was not found." -foregroundcolor "Red"}
            10{ write-host  "    10 The service is already running."-foregroundcolor "Red" }
            11{ write-host  "    11 The database to add a new service is locked."-foregroundcolor "Red" }
            12{ write-host  "    12 A dependency this service relies on has been removed from the system."-foregroundcolor "Red" }
            13{ write-host  "    13 The service failed to find the service needed from a dependent service."-foregroundcolor "Red" }
            14{ write-host  "    14 The service has been disabled from the system."-foregroundcolor "Red" }
            15{ write-host  "    15 The service does not have the correct authentication to run on the system."-foregroundcolor "Red" }
            16{ write-host  "    16 This service is being removed from the system."-foregroundcolor "Red" }
            17{ write-host  "    17 The service has no execution thread." -foregroundcolor "Red"}
            18{ write-host  "    18 The service has circular dependencies when it starts."-foregroundcolor "Red" }
            19{ write-host  "    19 A service is running under the same name."-foregroundcolor "Red" }
            20{ write-host  "    20 The service name has invalid characters."-foregroundcolor "Red" }
            21{ write-host  "    21 Invalid parameters have been passed to the service."-foregroundcolor "Red" }
            22{ write-host  "    22 The account under which this service runs is either invalid or lacks the permissions to run the service."-foregroundcolor "Red" }
            23{ write-host  "    23 The service exists in the database of services available from the system."-foregroundcolor "Red" }
            24{ write-host  "    24 The service is currently paused in the system."-foregroundcolor "Red" }
            }
        }
 
        function PowerShell-Wait($seconds)
        {
        #This function will cause the script to wait n seconds
           [System.Threading.Thread]::Sleep($seconds*1000)
        }
 
        function main()
        {
        #The main code. This function is called at the end of the script
        $svcD=gwmi win32_service -computername $mName -filter "name like '%elastic%'"
        write-host "----------------------------------------------------------------" 
 
        $svcD | ForEach-Object {
 
        write-host "Service to change user and pasword: "   $_.name -foregroundcolor "green"
 
        write-host "----------------------------------------------------------------" 
 
 
        if ($_.state -eq 'Running'){
            write-host "    Attempting to Stop the elasticsearch service..."
            $Value = $_.StopService()
            if ($Value.ReturnValue -eq '0'){
                $Change = 1      
                $Starts = 1     
                write-host "    Service stopped" -foregroundcolor "Green";
            }Else{
                write-host "    The stop action returned the following error: " -foregroundcolor "Red";
                PowerShell-PrintErrorCodes ($Value.ReturnValue)
                $Change = 0
                $Starts = 0
            }
        }Else{
            $Starts = 0
            $Change = 1
        }
        if ($Change -eq 1 ){
            write-host "    Attempting to change the service..."
            #This is the method that will do the user and pasword change
            $Value = $_.change($null,$null,$null,$null,$null,$null,$UserName,$Password,$null,$null,$null)
            if ($Value.ReturnValue -eq '0')
            {
                write-host "    Password and User changed" -foregroundcolor "Green";
                if ($Starts -eq 1){
                        write-host "    Attempting to start the service, waiting $SecondsToWait seconds..."
                        PowerShell-Wait ($SecondsToWait)
                        $Value =  $_.StartService()
                        if ($Value.ReturnValue -eq '0')
                            {
                                write-host "    Service started successfully." -foregroundcolor "Green";
                            }
                            Else
                            {
                            write-host "    Error while starting the service: " -foregroundcolor "Red";
                                PowerShell-PrintErrorCodes ($Value.ReturnValue)
                            }
                 }                                                          
             }Else{
                write-host "    The change action returned the following error: "  -foregroundcolor "Red";
                PowerShell-PrintErrorCodes ($Value.ReturnValue)
             }
          }                     
        write-host "----------------------------------------------------------------"   
        }
 
        }
 
        main   #Calling the main function that will do the job.

        }

        #end

    ##Make ESUsers


        Write-Host "Setting the elastic search username and password on $target.`n" -ForegroundColor Green

        Invoke-Command -ComputerName $machineName -ScriptBlock {
            Set-Location -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\bin\shield"
            $list = ".\esusers.bat useradd " + $Using:esUsername + " -p " + $Using:esPassword + " -r admin"
            $result = Invoke-Expression $list
            & .\esusers.bat list | Out-Null
        }

        Write-Verbose "Esuser added."


    Write-Verbose "End Data Grid Installation."
    ##End Initial For Loop
    } 


    ##Post-Install

    function Start-ESService {
        ##Check the elastic search service windows service status

        Write-Host "Checking the elastic search service.`n" -ForegroundColor Green

        $check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
         Select-Object -Property Status -ExpandProperty Status

        if("$check" -eq "Running"){
            Write-Verbose "The elasticserch service is running.`n"
        }
        if("$check" -eq "Stopped"){
            Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName | Start-Service
            Start-Sleep -s 10
        }
    }

    Start-ESService


    ##Check the ES service

    Function Check-ESService{
    $check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
     Select-Object -Property Status -ExpandProperty Status

    Write-Host "The elasticsearch service is: $check.`n" -ForegroundColor Green
    }

    Check-ESService

    ##Hook up with Elastic

    Function Ping-ES{
        Write-Host "The script will attempt to contact the node 6 times with 15 second pauses.`n" -ForegroundColor Green

        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $esUsername,$esPassword)))
        $i=0;
        Do{ ++$i;

            Try{
            $responceName = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
             -URI "http://$machineName`:9200" -Method 'GET' -ContentType 'application/json' |
             Select-Object -Property name -ExpandProperty name

            }
            Catch{
                $ErrorMessage = $_.Exception.Message
            } 
        if ($i -eq 1){
            Write-Host "Attempted to contact the node once." -ForegroundColor Green
        }else{
            Write-Host "Attempted to contact the node $i times." -ForegroundColor Green
        }
             if($i -eq 6){
             write-Host "The node cannot be contacted.  Here are the last 250 lines of the log file.  Good luck human!" -foregroundcolor Red
             Invoke-Command -ComputerName $target -ScriptBlock {Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\logs\$Using:Clustername.log -Tail 250}
             break;
             }


             if($responceName -eq $machineName){
                 Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
             -URI "http://$machineName`:9200" -Method 'GET' -ContentType 'application/json'
             }else{
                 Start-Sleep -s 15
             }


         }Until ($responceName -eq $machineName)
     }

     Ping-ES


    ##Additional tasks for the Monitor server Note the nodeType variable is coming from the top section of Update YML
     if($nodeType -eq "Monitor"){
             Write-Output "This a monitoring node some additional work must be done.`nStopping the elasticsearch service."

    #Add Custom marvel template.

        Write-Output "By default the marvel template has one replica.  Adding a custom marvel template to correct."

            $body = "{ ""template""`: "".marvel*"", ""order""`: 1, ""settings""`: { ""number_of_shards""`: 1, ""number_of_replicas""`: 0 } }"

            Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
            -URI "http://$machineName`:9200/_template/custom_marvel" -Method 'PUT' -ContentType 'application/json' -Body "$body"

        Write-Output "Above is the system responce from elastic.`n"

     #Add Custom kibana template.

        Write-Output "By default Kibana's template has one replica.  Adding a custom Kibana template to correct."


            $body = "{ ""template""`: "".kibana"", ""order""`: 1, ""settings""`: { ""number_of_shards""`: 1, ""number_of_replicas""`: 0 } }"

            Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
            -URI "http://$machineName`:9200/_template/custom_kibana" -Method 'PUT' -ContentType 'application/json' -Body "$body"

        Write-Output "Above is the system responce from elastic.`n"

     #Correct the number of replicas for marvel indexes if they exist.

        Write-Output "The inital indexes most likely have already been created with the incorrect number of replicas.`n"

        Write-Output "Updating the initial marvel indexes if they exist.`n"
        Try{
            $body = "{ ""index"" `: { ""number_of_replicas"" `: 0 } }"

            Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
            -URI "http://$machineName`:9200/.m*/_settings" -Method 'PUT' -ContentType 'application/json' -Body "$body" -ErrorAction Stop
        }
        catch [System.Net.WebException]{
            Write-Output "Marvel indexes were not found to update."    
        }
      #Copy Kibana folders if they do not exist

        Write-Output "Kibana is a visualization tool that includes Sense and the Marvel Application."
        Pop-Location
        Set-Location .\DataTron
        if((Test-Path .\kibana-4.5.4-windows) -eq $false){
        Write-Host "Kibana folder not found in DataTron Folder.  Please unzip the Kibana 4.5.4 installer to the DataTron Folder" -ForegroundColor "Yellow";
        Break
        }
        If((Test-Path "\\$target\$driveLetter`$\RelativityDataGrid\kibana-4.5.4-windows") -eq $false){

                #Copy Kibana folders
                    #start

                        Write-Output "Begin copying Kibana folders to $machineName."

                        $installPath = "\\" + $machineName + "\$driveLetter`$\RelativityDataGrid"

                        # Copies the package to the remote server(s) the package must be in the DataTron Folder.
                        Set-Location -Path (Get-Location).Drive.Root
                        Copy-Item .\DataTron\kibana-4.5.4-windows -Destination $InstallPath -Recurse -force

                        Write-Output "End Copy Kibana Folders to $target."

                    #end
            }

        ##Configuring Kibana

        Write-Output "Kibana needs to be configured to connect to the monitoing node's network host settings.`n"


            ##Update Kibana YML

                foreach($target in $machineName){

                    Invoke-Command -ComputerName $target -ScriptBlock {
                        $NodeName = $Using:machineName
                        $driveLetter = $Using:driveLetter

                        Write-Output "Configuring Kibana YML on  $NodeName.`n"

                            # Update the server host
                            $yml = Get-Content $driveLetter`:\RelativityDataGrid\kibana-4.5.4-windows\config\kibana.yml -Raw
                            $result = foreach ($line in $yml) {$line.Replace("# server.host: `"0.0.0.0`"", "server.host: " + $NodeName)}
                            $result | Out-File $driveLetter`:\RelativityDataGrid\kibana-4.5.4-windows\config\kibana.yml -Encoding ascii

                            # Update the server port
                            $yml = Get-Content $driveLetter`:\RelativityDataGrid\kibana-4.5.4-windows\config\kibana.yml -Raw
                            $result = foreach ($line in $yml) {$line.Replace("# server.port: 5601", "server.port: 5601")}
                            $result | Out-File $driveLetter`:\RelativityDataGrid\kibana-4.5.4-windows\config\kibana.yml -Encoding ascii

                            # Update the elasticsearch URL
                            $yml = Get-Content $driveLetter`:\RelativityDataGrid\kibana-4.5.4-windows\config\kibana.yml -Raw
                            $result = foreach ($line in $yml) {$line.Replace("# elasticsearch.url: ""http://localhost:9200`"", "elasticsearch.url: http://$NodeName`:9200")}
                            $result | Out-File $driveLetter`:\RelativityDataGrid\kibana-4.5.4-windows\config\kibana.yml -Encoding ascii

                        Write-Output "Finished Kibana YML Configuration."
  
                        Write-Output "Installing the Marvel application into Kibana.`n"

                        Try{
                            $ErrorActionPreference = "Stop";
                            Set-Location -Path (Get-Location).Drive.Root
                            & .\RelativityDataGrid\kibana-4.5.4-windows\bin\kibana.bat "plugin" "--install" "marvel" "--url" "file:///RelativityDataGrid/kibana-4.5.4-windows/marvel-2.3.5.tar.gz"
                        }
                        Catch [System.Management.Automation.RemoteException]
                        {
                            Write-Host "Marvel is aleady installed.`n" -ForegroundColor Green;
                        }

                        Write-Output "Installing the Sense application to Kibana.`n"

                        Try{
                            & .\RelativityDataGrid\kibana-4.5.4-windows\bin\kibana "plugin" "--install" "sense" "-u" "file:///RelativityDataGrid/kibana-4.5.4-windows/sense-2.0.0-beta7.tar.gz"
                        }
                        Catch [System.Management.Automation.RemoteException]
                        {
                            Write-Host "Sense is aleady installed.`n" -ForegroundColor Green;
                        }
                        Write-Output "Finished installing plugins to Kibana."
                    }
                }
            Write-Output "Finished Data Grid Install for the Monitoring node."

            
        #end if statement tasks for monitor cluster
    }

#Land back in DataTron Folder.
Set-Location -Path (Get-Location).Drive.Root
Set-Location .\Datatron
}