﻿<#
.SYNOPSIS
.DESCRIPTION
.PARAMETER DriveLetter
.PARAMETER MachineName
.EXAMPLE
#>
param(
[Parameter(Mandatory=$true)]
[char]$driveLetter,
[Parameter(Mandatory=$true)]
[string[]]$machineName,
[bool]$IsMaster,
[bool]$IsClient,
[bool]$IsData,
[bool]$IsMonitor,
[switch]$dontCopyFolders,
[switch]$dontInstalljava
)
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
Write-Output "Begin Data Tron:"

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
            Catch{
                $ErrorMessage = $_.Exception.Message
                Write-Host "An Execption has occurred.`n" -BackgroundColor Red -ForegroundColor White;
                Write-Output "The Exeception Message is $ErrorMessage.`n"
                Write-Output "A WinRM client error will occur if the computer is part of a workgroup and has not been added to the TrustedHosts list in Window Remote Management service.`n"
                Write-Output "Here are the Trusted Hosts listed for this machine.`n"
                Get-Item WSMan:\localhost\Client\TrustedHosts
                Write-Output "`nYou can add a trusted computer to the Trusted Host list now if it is missing.`n"
                Read-host "Press enter to add $target to the list of Trusted Hosts.`n to exit now press ctrl+c"
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
                Write-Output "Begin isntallation of Java on $target.`nExpect a long delay as Java installs."
                Invoke-Command $target -ScriptBlock {
                $version = Get-ChildItem 'C:\RelativityDataGrid\jdk-8*' | Select-Object Name -First 1 -ExpandProperty Name
                $filePath = "$Using:driveLetter`:\RelativityDataGrid\$version"
                $proc = Start-Process -FilePath $filePath -ArgumentList "/s" -Wait -PassThru
                $proc.WaitForExit()
                } -ErrorAction Stop
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

##Create environmental variables on the nodes.

    #start

    Write-Output "Begin setting the environmental variable for Java on $target."

    if(Resolve-Path "\\$target\$driveLetter`$\Program Files\Java\jdk*"){  
            Invoke-Command $target -ScriptBlock {
                $version = Get-ChildItem "$Using:driveLetter`:\Program Files\java\jdk*" | Select-Object Name -First 1 -ExpandProperty Name
                $filePath = "$Using:driveLetter`:\Program Files\Java\$version"
                [System.Environment]::SetEnvironmentVariable("KCURA_JAVA_HOME",$filePath,"Machine")
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
 
                #Update the marvel setting
                $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "host: [""http://" + $MonitoringNodeName + ":9200""]")}
                $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
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
 
                # Update the repo path $PathRepo
                $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                $result = foreach ($line in $yml) {$line.Replace("#path.repo: [""\\\\MY_SERVER\\Snapshots""]", "path.repo: " + " $PathRepo")}
                $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
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

                #Update the marvel setting
                $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "host: [""http://" + $MonitoringNodeName + ":9200""]")}
                $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
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
 
                # Update the repo path $PathRepo
                $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                $result = foreach ($line in $yml) {$line.Replace("#path.repo: [""\\\\MY_SERVER\\Snapshots""]", "path.repo: " + " $PathRepo")}
                $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
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
 
                #Update the marvel setting
                $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                $result = foreach ($line in $yml) {$line.Replace("host: [""http://<<your-es-monitoring-machine-name-01>>:9200"",""http://<<your-es-monitoring-machine-name-02>>:9200""]", "host: [""http://" + $MonitoringNodeName + ":9200""]")}
                $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
 
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
 
                # Update the repo path $PathRepo
                $yml = Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Raw
                $result = foreach ($line in $yml) {$line.Replace("#path.repo: [""\\\\MY_SERVER\\Snapshots""]", "path.repo: " + " $PathRepo")}
                $result | Out-File $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml -Encoding ascii
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
            [System.Environment]::SetEnvironmentVariable("KCURA_JAVA_HOME",$filePath,"Machine")
            $sysEnv = [System.Environment]::GetEnvironmentVariable("KCURA_JAVA_HOME","Machine")
            Write-Output "The KCURA_JAVA_HOME system environmental variable was set to: $sysEnv"
            & cd\
            & cd "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\bin\"
            $install = "install"
            .\kservice.bat $install
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

Write-Output "Checking the elastic search service."

##Check the elastic search service windows service status

$check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
 Select-Object -Property Status -ExpandProperty Status

if("$check" -eq "Running"){
    Write-Host "The elasticserch service is running."
}
if("$check" -eq "Stopped"){
    Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName | Start-Service
    Start-Sleep -s 10
}

##Check it again

$check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
 Select-Object -Property Status -ExpandProperty Status

Write-Host "The elasticsearch servie is: $check."

##Hook up with Elastic

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


##Additional tasks for the Monitor server Note the nodeType variable is coming from the top section of Update YML
 if($nodeType -eq "Monitor"){
     Write-Output "This a monitoring node some additional work must be done.`nStopping the elasticsearch service."
     Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName | Stop-Service
     Start-Sleep -s 10
     Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName
 
    ##Drop the Marvel folder
    Write-Output "Removing the marvel plugin for the monitoring node."
    Start-Sleep -s 10
    Invoke-Command -ComputerName $machineName -ScriptBlock{
    Remove-Item -Path "$Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\plugins\marvel-agent" -Recurse
}

##Restart Elastic Search
$check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
 Select-Object -Property Status -ExpandProperty Status

Write-Output "Checking the elastic search service."

##Check the elastic search service windows service status

$check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
 Select-Object -Property Status -ExpandProperty Status

if("$check" -eq "Running"){
    Write-Host "The elasticserch service is running."
}
if("$check" -eq "Stopped"){
    Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName | Start-Service
    Start-Sleep -s 10
}

##Check it again

$check = Get-Service -Name elasticsearch-service-x64 -ComputerName $machineName |
 Select-Object -Property Status -ExpandProperty Status

Write-Host "The elasticsearch service is: $check."

##Hook up with Elastic

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
         Invoke-Command -ComputerName $target -ScriptBlock {Get-Content $Using:driveLetter`:\RelativityDataGrid\elasticsearch-main\logs\$Using:ClusternameMON.log -Tail 250}
         break;
     }


     if($responceName -eq $machineName){
         Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
         -URI "http://$machineName`:9200" -Method 'GET' -ContentType 'application/json'
     }else{
         Start-Sleep -s 15
     }


}Until ($responceName -eq $machineName)

Write-Output "By default the marvel template has one replica.  Adding a custom marvel template to correct."


    $body = "{ ""template""`: "".marvel*"", ""order""`: 1, ""settings""`: { ""number_of_shards""`: 1, ""number_of_replicas""`: 0 } }"

    Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
    -URI "http://$machineName`:9200/_template/custom_marvel" -Method 'PUT' -ContentType 'application/json' -Body "$body"

Write-Output "Above is the system responce from elastic.`n"


Write-Output "By default Kibana's template has one replica.  Adding a custom Kibana template to correct."


    $body = "{ ""template""`: "".kibana"", ""order""`: 1, ""settings""`: { ""number_of_shards""`: 1, ""number_of_replicas""`: 0 } }"

    Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
    -URI "http://$machineName`:9200/_template/custom_marvel" -Method 'PUT' -ContentType 'application/json' -Body "$body"

Write-Output "Above is the system responce from elastic.`n"



Write-Output "The inital indexes most likely have already been created with the incorrect number of replicas.`n"

Write-Output "Updating the initial marvel indexes.`n"

$body = "{ ""index"" `: { ""number_of_replicas"" `: 0 } }"

Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}`
-URI "http://$machineName`:9200/.m*/_settings" -Method 'PUT' -ContentType 'application/json' -Body "$body"

Write-Output "Above is the system responce from elastic.`n"

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