set-location /DataTron

$nodes = @(
,("MasterNode1" , "Master")
,("DataNode1" , "Data")
,("DataNode2" , "Data")
,("ClientNode1" , "Client")
,("MonitoringCluster" , "Monitor")
)

foreach($node in $nodes) {
$args = "-file .\Run-DataTron.ps1", "-driveLetter c", ("-machineName " + $node.get(0)), ("-nodeType " + $node.get(1))
start-process powershell -ArgumentList $args 
}