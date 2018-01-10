set-location /DataTron

#Specify the drive letter where the service and java will be installed.

$driveLetter = 'c'

#Specity each node name to install along with the node type, for example:  ,("MyClientNode01" , "Client")
#Begin each line with a comma, use double quotes to contain each value, separte the values with a comma.  

#Add or remove lines as needed.  


$nodes = @(
,("MasterNode1" , "Master")
,("DataNode1" , "Data")
,("DataNode2" , "Data")
,("ClientNode1" , "Client")
,("MonitoringCluster" , "Monitor")
)

foreach($node in $nodes) {
$args = "-file .\Run-DataTron.ps1", "-driveLetter $driveLetter", ("-machineName " + $node.get(0)), ("-nodeType " + $node.get(1))
start-process powershell -ArgumentList $args 
}