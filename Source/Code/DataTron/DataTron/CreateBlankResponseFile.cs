using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace DataTron
{
    public static class CreateBlankResponseFile
    {
        public static string ResponseFileText = @"

#Relativity Data Grid Response File

#Enter the cluster name below. Use short descriptive name without special characters, for example: kCuraProd01

ClusterName = 

#Node name is the FQDN of the this node where the installer is running.

NodeName = 

#UnicastHosts is a list of all nodes in the cluster.  This setting will include all nodes including this node where the installer is running.
#Do not include the monitoring in this list unless this is the monitoring node then only add the monitoring node name.
#Enter the values as an array for strings for example: ""node1"",""node2"",""node3""

UnicastHosts = 

#Enter true if the node will fuction as a master node, monitoring node, or a combined role node.

IsMaster = 

#Enter true if the node will fuction as a data nodem, monitoring node, or a combined role node.

IsData = 

#Enter true if the node will be a monitoring node.

IsMonitor = 

#Enter the number of Master Nodes in the cluster.

MasterNodeNumber = 

#Enter the name of the Monitoring Node if it exists otherwise leave blank

MonitoringNode = 

#Ener the path where data will be stored on this node.  Note a blank file will be created for client and master types.  The folder is created by the 

installer.

DataPath = 

#Enter the network location of the backup.  This backup location must be exist and shared to the Relativity Service Account.

PathRepository = 

#Elastic uses a plugin called shield with a REST username and password to protect the cluster from unauthorized access.  
#Create a new username.  This is not a domain account and is used solely for authentication with shield.

EsUserName = 

#Create a pssword for the shield account above.

EsPassWord = 

#Shield will authenticate to Relativity using a Relativity Web Server.
#This can be a single Relativity server name or a load balance URL.
#The Web server or load balancer must have a valid SSL certificate.

AuthenticationWebServer = 

#The Relativity Service Account user name use the domain\username format.  If the Service Account is not in a domain use the .\username format.

ServiceAccountUserName = 

#The Relativity Service Account password

ServiceAccountPassWord = 

";
        public static void MakeResponseFile()
        {
            File.WriteAllText("DataGridResponseFile.txt", ResponseFileText);
        }
    }
}
