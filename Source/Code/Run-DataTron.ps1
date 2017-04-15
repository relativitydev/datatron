<#
.SYNOPSIS
This script is used to install Relativity Data Grid to a server or "node", refered to as a "install run". 

.DESCRIPTION

The purpose of this script is to install Relativity Data Grid to a single server.

The script relies on a file in the script directory called Config.psd1

This configuration file can be created by running this script with  only the -config switch and no other arguements.

To install Relativity Data Grid to a server you must specify the drive letter that will host the service and the machine name.

.NOTES

The script can also be used to create a config file for an install run.

The script must reside in the root folder DataTron.

The DataTron folder must contain the RelativityDataGrid Folder.

The RelativityDataGrid folder must contain a jdk version 8 installer and the certificate which will be used by shield for authentication.

A Config.psd1 file must be generated before doing an install run of the script.

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
.\DataTron\Run-DataTron6.0.ps1 -Config

This will create a Config.psd1 file in the directory for and install run.
This is a switch and cannot be run with any other parameters.

.EXAMPLE
.\Run-DataTron3.0.ps1 -driveLetter c -machineName someserver -IsMaster $true

Once a Config.psd1 file is created the script can be used to do an install run.
This example installs RelativityDataGrid to the c drive of someserver.


.EXAMPLE
.\DataTron\Run-DataTron3.0.ps1 -driveLetter c -machineName someserver -IsMaster $true -dontCopyfolders

Does an install run but does not copy the RelativityDataGrid folder.

.EXAMPLE
.\DataTron\Run-DataTron3.0.ps1 -driveLetter c -machineName someserver -IsMaster $true -dontInstallJava

Does an install run but does not install Java.

.EXAMPLE
.\DataTron\Run-DataTron3.0.ps1 -driveLetter c -machineName someserver -IsMaster $true -dontInstallJava -dontCopyfolders

Does an install run but does not install Java and does not copy the installation folders.
#>
[CmdletBinding(DefaultParameterSetName='Install')]
param(
[Parameter(Mandatory=$true, ParameterSetName = 'Install')]
[char]$driveLetter,

[Parameter(Mandatory=$true, ParameterSetName = 'Install')]
[string[]]$machineName,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[bool]$IsMaster,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[bool]$IsClient,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[bool]$IsData,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[bool]$IsMonitor,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$dontCopyFolders,

[Parameter(Mandatory=$false, ParameterSetName = 'Install')]
[switch]$dontInstalljava,

[Parameter(Mandatory=$true, ParameterSetName = 'Config')]
[switch]$Config
)
if($Config){

##Get Datatron Data from the User

##Create the psd1 file

New-Item .\DataTron\Config.psd1 -type file

##Prep the file
"@{" | Out-File .\DataTron\Config.psd1

clear
Write-host "Welcome to DataTron Human`n"
Write-Host "We need some input to install Data Grid`n"
Start-Sleep -s 1


##Get Username
    $UserName = Read-Host "Enter the Relativity User Account`n"
    $yn = "0"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $UserName is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $UserName = Read-Host "Enter the Relativity User Account`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $Username`n"
    "`t`tUserName = " + """$UserName"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls
    
##Get Password
    $Password = Read-Host "Enter the Relativity User Account Password`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $Password is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $UserName = Read-Host "Enter the Relativity User Account Password`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $Password`n"
    "`t`tPassword = " + """$Password"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls
    
##Get Monitoring Node Name
    $MonitoringNodeName = Read-Host "Enter the Name of the Monitoring Node`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $MonitoringNodeName is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $MonitoringNodeName = Read-Host "Enter the Name of the Monitoring Node`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $MonitoringNodeName`n"
    "`t`tMonitoringNodeName = " + """$MonitoringNodeName"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get Production Array

   $q = "0"
   Remove-Variable q
   Do{
       If(!$q){
           $stackVar = "`"" + "[" + "`"" + "`""
           } 
       $array = Read-Host "Enter the name of each server in the production cluster`nYou must enter at least one server name`nIf you are done adding servers type exit"
       if($array -eq "exit"){
           $q = "exit"
           "`t`tProductionHostsArray = " + $stackVar.Substring(0,$stackVar.Length-3) + "]" + "`";" | Add-Content .\DataTron\Config.psd1
           }
           Write-Host "You entered: $array is this correct?`n"
           $q = Read-Host "Type y to confirm, n to remove the entry, exit to exit"
       If($q -eq "y"){
           $stackVar += $array + "`"" + "`"" + "," + "`"" + "`""
       }
       If($q -eq "n"){
           Clear-Variable array
       }
   }Until($q -eq "exit")
Start-Sleep -s 1
cls

##Get the produciton cluster name
    $Clustername = Read-Host "Enter the Name of the Production Cluster`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $Clustername is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $Clustername = Read-Host "Enter the Name of the Production Cluster`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $Clustername`n"
    "`t`tClustername = " + """$Clustername"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the monitoring cluster name
    $ClusternameMON = Read-Host "Enter the Name of the Monitoring Cluster`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $ClusternameMON is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $ClusternameMON = Read-Host "Enter the Name of the Monitoring Node`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $ClusternameMON`n"
    "`t`tClusternameMON = " + """$ClusternameMON"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get minimum number of master nodes
    $MinimumMasterNode = Read-Host "Enter minimum number of master nodes for the production cluster`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $MinimumMasterNode is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $MinimumMasterNode = Read-Host "Enter minimum number of master nodes for the production cluster`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $MinimumMasterNode`n"
    "`t`tMinimumMasterNode = " + "$MinimumMasterNode;" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the data path for the master node
    $PathDataMaster = Read-Host "Enter data path for the master node`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $PathDataMaster is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $PathDataMaster = Read-Host "Enter data path for the master node`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $PathDataMaster`n"
    "`t`tPathDataMaster = " + """$PathDataMaster"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the data path for the client node(s)
    $PathDataClient = Read-Host "Enter data path for the client node(s)`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $PathDataClient is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $PathDataClient = Read-Host "Enter data path for the client node(s)`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $PathDataClient`n"
    "`t`tPathDataClient = " + """$PathDataClient"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the data path for the data node(s)
    $PathDataData = Read-Host "Enter data path for the data node(s)`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $PathDataData is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $PathDataData = Read-Host "Enter data path for the data node(s)`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $PathDataData`n"
    "`t`tPathDataData = " + """$PathDataData"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the data path for the monitoring node(s)
    $PathDataMonitor = Read-Host "Enter data path for the monitoring node(s)`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $PathDataMonitor is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $PathDataMonitor = Read-Host "Enter data path for the monitoring node(s)`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $PathDataMonitor`n"
    "`t`tPathDataMonitor = " + """$PathDataMonitor"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the name of the SQL server(s)
    $SQLServers = Read-Host "Enter names of the SQL servers(s)`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $SQLServers is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $SQLServers = Read-Host "Enter names of the SQL servers(s)`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $SQLServers`n"
    "`t`tSQLServers = " + """$SQLServers"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the name of the web server for shield authentication
    $WebServer = Read-Host "Enter names of the web server for shield authentication`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $WebServer is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $WebServer = Read-Host "Enter names of the web server for shield authentication`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $WebServer`n"
    "`t`tWebServer = " + """$WebServer"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Get the backup path location
    $PathRepo = Read-Host "Enter the backup path location`nThe format of the backup path must be like \\\\servername\\foldername"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $PathRepo is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $WebServer = Read-Host "Enter names of the web server for shield authentication`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $PathRepo`n"
    "`t`tPathRepo = " + "`"" + "[" + "`"" + """$PathRepo""" + "`"" +"]" + "`";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Create a new for the shield useraccount
    $esUsername = Read-Host "Enter name for the esadmin account`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $esUsername is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $esUsername = Read-Host "Enter name for the esadmin account`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $esUsername`n"
    "`t`tesUsername = " + """$esUsername"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

##Create a new for the shield useraccount passoword
    $esPassword = Read-Host "Enter esadmin account password`n"
    Clear-Variable yn
    While($yn -ne "y"){

    Write-Host "You entered: $esPassword is this correct y/n`n"
    $yn = Read-Host 
        If($yn -eq "n"){
        $esPassword = Read-Host "Enter esadmin account password`n"
        $yn = Read-Host
        }
    }
    Write-Host "Set $esPassword`n"
    "`t`tesPassword = " + """$esPassword"";" | Add-Content .\DataTron\Config.psd1
    Start-Sleep -s 1
    cls

"`t`tSecondsToWait = 1;" | Add-Content .\DataTron\Config.psd1
"}" | Add-Content .\DataTron\Config.psd1


Get-Content .\DataTron\Config.psd1
Start-Sleep -s 5

}

else{

    #Import Variables from the psd1 file in the same directory as this script.
    cd\
    $currentScriptDir = ".\DataTron"
    Import-LocalizedData -BaseDirectory $currentScriptDir -FileName Config.psd1 -BindingVariable Data


    #Variables for "Update the servicename"
    [string]$UserName = $Data.UserName
    [string]$Password = $Data.Password
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
    [string]$esPassword = $Data.esPassword

    ##Test the machinename
    Write-Output "Checking the connection to $machineName.`n"
    if (Test-Connection -ComputerName $machineName -Quiet -Count 1){
    }else{
        Write-Output "The connection to $machineName was not succssesfull would you like to try to ping the server?`n"
        $ping = Read-Host "Press enter to not ping $machineName and stop the script.`nType yes to ping $machineName.`n"
    If($ping -eq "yes"){
        Test-Connection -ComputerName $machineName
    }
    break}
    Write-Output "Connection to $machineName successful."
    #Begin The installer.

    Foreach($target in $machineName){ 
    cls
    Write-Output "Begin Data Tron:`n"

    ##Copy the Data Grid Package

        #start

        If($dontCopyFolders -eq $false){

            Write-Output "Begin Copy Folders to $target"

            $installPath = "\\" + $target + "\$driveLetter`$\"

            # Copies the package to the remote server, the package must be in the DataTron Folder.
            cd\
            Copy-Item .\DataTron\RelativityDataGrid -Destination $InstallPath -Recurse -force

            Write-Output "Finished copying folders to $target."
        }
        #end

    #Install Java Silently.

        #start
        IF((Test-Path "\\$target\c`$\Program Files\Java\jdk*") -eq $false){

            If($dontInstalljava -eq $false){

                Write-Output "Begin installation of Java on $target.`nExpect a long delay as Java installs."
                Try{
                    Invoke-Command $target -ScriptBlock {
                        $version = Get-ChildItem 'C:\RelativityDataGrid\jdk-8*' | Select-Object Name -First 1 -ExpandProperty Name
                        $filePath = "$Using:driveLetter`:\RelativityDataGrid\$version"
                        $proc = Start-Process -FilePath $filePath -ArgumentList "/s" -Wait -PassThru
                        $proc.WaitForExit()
                    } -ErrorAction Stop
                }
                Catch [System.Management.Automation.Remoting.PSRemotingTransportException]{
                    $ErrorMessage = $_.Exception.Message
                    Write-Host "An Execption has occurred.`n" -BackgroundColor Green -ForegroundColor Black;
                    Write-Output "The Exeception Message is:`n $ErrorMessage.`n"
                    Write-Output "A WinRM client error will occur if the computer is part of a workgroup and has not been added to the TrustedHosts list in Window Remote Management service.`n"
                    Write-Output "Here are the Trusted Hosts listed for this machine.`nThe output will be blank if no Trusted Hosts exist.`n"
                    Get-Item WSMan:\localhost\Client\TrustedHosts
                    Write-Output "`nThe computer will be added to the Trusted Host list now if it is missing.`n"

                    $A = Get-Item wsman:\localhost\Client\TrustedHosts | Select Value -ExpandProperty Value
                    If($A){
                        $A = $A + ",$target"
                    }
                    IF(!$A){
                        $A = $target
                    }
                    set-item wsman:\localhost\Client\TrustedHosts -value "$A" -Force
                    sleep -s 5
                    Get-Item WSMan:\localhost\Client\TrustedHosts
                    Write-Host "The remote machine is now added to TrustedHosts the installation will continue.`n" -BackgroundColor Green -ForegroundColor Black;
                    Write-Output "Begin installation of Java on $target.`nExpect a long delay as Java installs."
                    Invoke-Command $target -ScriptBlock {
                        $version = Get-ChildItem 'C:\RelativityDataGrid\jdk-8*' | Select-Object Name -First 1 -ExpandProperty Name
                        $filePath = "$Using:driveLetter`:\RelativityDataGrid\$version"
                        $proc = Start-Process -FilePath $filePath -ArgumentList "/s" -Wait -PassThru
                        $proc.WaitForExit()
                } -ErrorAction Stop
                Catch
                {
                $ErrorMessage = $_.Exception.Message
                $ErrorName = $_.Exception.GetType().Fullname
                $ErrorItem = $_.Exceception.ItemName
                Write-Output "An error $ErrorName has occurred. The error message is $ErrorMessage.  The item that cause the error is $ErrorItem."
                }
                }
        
                Write-Output "End installation of Java on $target."
            }
        }else{
            $javaPath = Resolve-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*" | select -Property Path -ExpandProperty Path 
            Write-Host "Java is installed here: $javaPath." -BackgroundColor Green -ForegroundColor Black;
        }
        if((Resolve-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*") -eq $false){
            Write-Host "Java failed to install on $target." 
            Exit
        }
        #end

    ##Create environmental variables on the node.

        #start

        Write-Output "Begin setting the environmental variable for Java on $target."

        if(Resolve-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*"){  
                Invoke-Command $target -ScriptBlock {
                    $version = Get-ChildItem "$Using:driveLetter`:\Program Files\java\jdk*" | Select-Object Name -First 1 -ExpandProperty Name
                    $filePath = "$Using:driveLetter`:\Program Files\Java\$version"
                    & setx KCURA_JAVA_HOME "$filePath" /m
                    $sysEnv = [System.Environment]::GetEnvironmentVariable("KCURA_JAVA_HOME","Machine")
                    Write-Output "The KCURA_JAVA_HOME system environmental variable was set to: $sysEnv"
                }
        }else{
            Write-Host "Java is not installed on $target.`n" -BackgroundColor Red -ForegroundColor Black;

            Write-Host "If you are using the -dontInstallJava switch try the script again without that switch."
            Exit
        }
    

        Write-Output "End setting the environmental variable for Java on $target."

        #end




    ##Install the certs into Windows and Java

        #start

        Write-Output "Begin adding certificates to Windows and Java to $target."

        Invoke-Command $target -ScriptBlock {
            #Windows

            $certdir = "$Using:driveLetter`:\RelativityDataGrid\*.cer"
            $certname = Get-ChildItem -Path $certdir | Select-Object name -ExpandProperty Name 
            Import-Certificate -FilePath "$Using:driveLetter`:\RelativityDataGrid\$certname" -CertStoreLocation Cert:\LocalMachine\Root


            #Java
            $installedVersion =  Get-ChildItem "$Using:driveLetter`:\Program Files\Java\jdk*" | Select-Object Name -First 1 -ExpandProperty Name
            $keyTool = "$Using:driveLetter`:\Program Files\Java\$installedVersion\bin\keytool.exe"
            $keystore = "$Using:driveLetter`:\Program Files\Java\$installedVersion\jre\lib\security\cacerts"
            $list = "-importcert","-noprompt","-alias","shield","-keystore","""$keystore""","-storepass","changeit","-file","""$Using:driveLetter`:\RelativityDataGrid\$certname"""
            & cd\ 
            & cd "$Using:driveLetter`:\Program Files\Java\$installedVersion\bin"
            & .\keytool.exe $list 2>&1 | %{ "$_" }
        }


        Write-OutPut "End adding certificates to Windows and Java to $target."

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

        Write-Output "Updating the elasticsearch YML on $target the selected role is $nodeType."

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
                            Write-Host "This is a monitoring node the marvel plugin folder will be removed.`n" -BackgroundColor Green -ForegroundColor Black;
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

            #end script block
            }

        #end foreach loop in Update YML

        }

        Write-Output "YML Update Completed."

        #end

    ##Install ElasticSearch service

        #start

        Write-Output "Installing Elasticsearch service on $target."

        foreach($target in $machineName){
            Invoke-Command -ComputerName $target -ScriptBlock {
                $version = Get-ChildItem "$Using:driveLetter`:\Program Files\java\jdk*" | Select-Object Name -First 1 -ExpandProperty Name
                $filePath = "$Using:driveLetter`:\Program Files\Java\$version"
                $env:KCURA_JAVA_HOME = $filePath
                $env:KCURA_JAVA_HOME
                $KCURA_JAVA_HOME = $filePath
                $KCURA_JAVA_HOME
                & cd\
                & cd "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\bin\"
                $install = "install"
                & .\kservice.bat $install
            }
        }
        Write-Output "Finished installing Elasticsearch service on $target."

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
            0{ write-host  "    0 The request was accepted." -foregroundcolor "white" -BackgroundColor "Red" }
            1{ write-host  "    1 The request is not supported." -foregroundcolor "white" -BackgroundColor "Red" }
            2{ write-host  "    2 The user did not have the necessary access."-foregroundcolor "white" -BackgroundColor "Red"}
            3{ write-host  "    3 The service cannot be stopped because other services that are running are dependent on it." -foregroundcolor "white" -BackgroundColor "Red"}
            4{ write-host  "    4 The requested control code is not valid, or it is unacceptable to the service." -foregroundcolor "white" -BackgroundColor "Red"}
            5{ write-host  "    5 The requested control code cannot be sent to the service because the state of the service (Win32_BaseService State property) is equal to 0, 1, or 2." -foregroundcolor "white" -BackgroundColor "Red"}
            6{ write-host  "    6 The service has not been started." -foregroundcolor "white" -BackgroundColor "Red"}
            7{ write-host  "    7 The service did not respond to the start request in a timely fashion." -foregroundcolor "white" -BackgroundColor "Red"}
            8{ write-host  "    8 Unknown failure when starting the service."-foregroundcolor "white" -BackgroundColor "Red" }
            9{ write-host  "    9 The directory path to the service executable file was not found." -foregroundcolor "white" -BackgroundColor "Red"}
            10{ write-host  "    10 The service is already running."-foregroundcolor "white" -BackgroundColor "Red" }
            11{ write-host  "    11 The database to add a new service is locked."-foregroundcolor "white" -BackgroundColor "Red" }
            12{ write-host  "    12 A dependency this service relies on has been removed from the system."-foregroundcolor "white" -BackgroundColor "Red" }
            13{ write-host  "    13 The service failed to find the service needed from a dependent service."-foregroundcolor "white" -BackgroundColor "Red" }
            14{ write-host  "    14 The service has been disabled from the system."-foregroundcolor "white" -BackgroundColor "Red" }
            15{ write-host  "    15 The service does not have the correct authentication to run on the system."-foregroundcolor "white" -BackgroundColor "Red" }
            16{ write-host  "    16 This service is being removed from the system."-foregroundcolor "white" -BackgroundColor "Red" }
            17{ write-host  "    17 The service has no execution thread." -foregroundcolor "white" -BackgroundColor "Red"}
            18{ write-host  "    18 The service has circular dependencies when it starts."-foregroundcolor "white" -BackgroundColor "Red" }
            19{ write-host  "    19 A service is running under the same name."-foregroundcolor "white" -BackgroundColor "Red" }
            20{ write-host  "    20 The service name has invalid characters."-foregroundcolor "white" -BackgroundColor "Red" }
            21{ write-host  "    21 Invalid parameters have been passed to the service."-foregroundcolor "white" -BackgroundColor "Red" }
            22{ write-host  "    22 The account under which this service runs is either invalid or lacks the permissions to run the service."-foregroundcolor "white" -BackgroundColor "Red" }
            23{ write-host  "    23 The service exists in the database of services available from the system."-foregroundcolor "white" -BackgroundColor "Red" }
            24{ write-host  "    24 The service is currently paused in the system."-foregroundcolor "white" -BackgroundColor "Red" }
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
 
        write-host "Services found:"  $svcD.Count -foregroundcolor "green"
        $svcD | ForEach-Object {
 
        write-host "Service to change user and pasword: "   $_.name -foregroundcolor "green"
 
        write-host "----------------------------------------------------------------" 
 
 
               if ($_.state -eq 'Running')
               {
           
                   write-host "    Attempting to Stop the elasticsearch service..."
                   $Value = $_.StopService()
                    if ($Value.ReturnValue -eq '0')
 
                       {
                        $Change = 1      
                        $Starts = 1     
                        write-host "    Service stopped" -foregroundcolor "white" -BackgroundColor "darkgreen"
                        }
                       Else
                       {
                            write-host "    The stop action returned the following error: " -foregroundcolor "white" -BackgroundColor "Red"
                            PowerShell-PrintErrorCodes ($Value.ReturnValue)
                             $Change = 0
                             $Starts = 0
                        }
               }
               Else
               {
         
                 $Starts = 0
                 $Change = 1
         
               }
        
                   if ($Change -eq 1 )
                   {
                     write-host "    Attempting to change the service..."
                       #This is the method that will do the user and pasword change
                       $Value = $_.change($null,$null,$null,$null,$null,$null,$UserName,$Password,$null,$null,$null)
                       if ($Value.ReturnValue -eq '0')
                        {
                           write-host "    Password and User changed" -foregroundcolor "white" -BackgroundColor "darkgreen"
                           if ($Starts -eq 1)
                                {
                                    write-host "    Attempting to start the service, waiting $SecondsToWait seconds..."
                                    PowerShell-Wait ($SecondsToWait)
                                    $Value =  $_.StartService()
                                    if ($Value.ReturnValue -eq '0')
                                        {
                                            write-host "    Service started successfully." -foregroundcolor "white" -BackgroundColor "darkgreen"
                                        }
                                     Else
                                        {
                                        write-host "    Error while starting the service: " -foregroundcolor "white" -BackgroundColor "red"
                                         PowerShell-PrintErrorCodes ($Value.ReturnValue)
                                        }
                                }                                                          
                            }
                        Else
                         {
                         write-host "    The change action returned the following error: "  -foregroundcolor "white" -BackgroundColor "red"
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

        #start

        Write-Host "Setting the elastic search username and password on $target."

        Invoke-Command -ComputerName $machineName -ScriptBlock {
            Set-Location -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\bin\shield"
            $list = ".\esusers.bat useradd " + $Using:esUsername + " -p " + $Using:esPassword + " -r admin"
            $result = Invoke-Expression $list
            & .\esusers.bat list
        }

        Write-Host "Esuser added."

        #end



    Write-Output "End Data Grid Installation."
    ##End Initial For Loop
    } 


    ##Post-Install

    function Start-ESService {
        ##Check the elastic search service windows service status

        Write-Output "Checking the elastic search service."

        $check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
         Select-Object -Property Status -ExpandProperty Status

        if("$check" -eq "Running"){
            Write-Host "The elasticserch service is running."
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

    Write-Host "The elasticsearch servie is: $check."
    }

    Check-ESService

    ##Hook up with Elastic

    Function Ping-ES{
        Write-Host "The node can take up to 45 seconds to start.`nThe script will attempt to contact the node 5 times with 15 second pauses."

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

        Write-Output "The script has attempted to contact the node $i times"
             if($i -eq 5){
             write-Host "The node cannot be contacted.  Here are the last 250 lines of the log file.  Good luck human!" -foregroundcolor "black" -BackgroundColor "red"
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

        Write-Output "Updating the initial marvel indexes.`n"

        $body = "{ ""index"" `: { ""number_of_replicas"" `: 0 } }"

        Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
        -URI "http://$machineName`:9200/.m*/_settings" -Method 'PUT' -ContentType 'application/json' -Body "$body"

        Write-Output "Above is the system responce from elastic.`n"

      #Ask if Kibana folders need to be copied and copy them if the answer is yes.

        Write-Output "Kibana is a visualization tool that includes Sense and the Marvel Application."
        $question = Read-Host "To copy the Kibana folders to the monitoring server now type yes.  To skip press enter."

            IF($question -eq "yes"){
                #Copy Kibana folders
                    #start

                        Write-Output "Begin copying Kibana folders to $machineName."

                        $installPath = "\\" + $machineName + "\$driveLetter`$\RelativityDataGrid"

                        # Copies the package to the remote server(s) the package must be in the DataTron Folder.
                        cd\
                        Copy-Item .\DataTron\kibana-4.5.4-windows -Destination $InstallPath -Recurse -force

                        Write-Output "End Copy Kibana Folders to $target."

                    #end
            }

        ##Configuring Kibana

        Write-Output "Kibana needs to be configured to connect to the monitoing node's network host settings."
        $question = Read-Host "To configure Kibana now type yes.  To skip press enter."

            IF($question -eq "yes"){

            ##Update Kibana YML

                foreach($target in $machineName){

                    Invoke-Command -ComputerName $target -ScriptBlock {
                        $NodeName = $Using:machineName
                        $driveLetter = $Using:driveLetter

                        Write-Output "Configuring Kibana YML on  $NodeName."

                        Write-Output "The drive letter passed = $driveLetter."
                        Write-Output "TheNodeName passed = $NodeName."

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
                        & cd\
                        & .\RelativityDataGrid\kibana-4.5.4-windows\bin\kibana.bat "plugin" "--install" "marvel" "--url" "file:///RelativityDataGrid/kibana-4.5.4-windows/marvel-2.3.5.tar.gz"
                        Write-Output "Installing the Sense application to Kibana.`n"
                        & .\RelativityDataGrid\kibana-4.5.4-windows\bin\kibana "plugin" "--install" "sense" "-u" "file:///RelativityDataGrid/kibana-4.5.4-windows/sense-2.0.0-beta7.tar.gz"

                        Write-Output "Finished installing plugins to Kibana."
                    }
                }
            Write-Output "Finished Data Grid Install for the Monitoring node."

            }
        #end if statement tasks for monitor cluster
    }
}
#Land back in DataTron Folder.
& cd .\DataTron