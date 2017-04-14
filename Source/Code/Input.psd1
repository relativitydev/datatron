##Get Datatron Data from the User
 
##Create the psd1 file
 
New-Item .\Config.psd1 -type file
 
##Prep the file
"@{" | Out-File .\Config.psd1
 
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
    "`t`tUserName = " + """$UserName"";" | Add-Content .\Config.psd1
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
    "`t`tPassword = " + """$Password"";" | Add-Content .\Config.psd1
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
    "`t`tMonitoringNodeName = " + """$MonitoringNodeName"";" | Add-Content .\Config.psd1
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
           "`t`tProductionHostsArray = " + $stackVar.Substring(0,$stackVar.Length-3) + "]" + "`";" | Add-Content .\Config.psd1
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
    "`t`tClustername = " + """$Clustername"";" | Add-Content .\Config.psd1
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
    "`t`tClusternameMON = " + """$ClusternameMON"";" | Add-Content .\Config.psd1
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
    "`t`tMinimumMasterNode = " + "$MinimumMasterNode;" | Add-Content .\Config.psd1
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
    "`t`tPathDataMaster = " + """$PathDataMaster"";" | Add-Content .\Config.psd1
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
    "`t`tPathDataClient = " + """$PathDataClient"";" | Add-Content .\Config.psd1
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
    "`t`tPathDataData = " + """$PathDataData"";" | Add-Content .\Config.psd1
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
    "`t`tPathDataMonitor = " + """$PathDataMonitor"";" | Add-Content .\Config.psd1
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
    "`t`tSQLServers = " + """$SQLServers"";" | Add-Content .\Config.psd1
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
    "`t`tWebServer = " + """$WebServer"";" | Add-Content .\Config.psd1
    Start-Sleep -s 1
    cls
 
##Get the backup path location
    $PathRepo = Read-Host "Enter the backup path location`nThe format of the backup path must be like \\\\servernaem\\foldername"
    Clear-Variable yn
    While($yn -ne "y"){