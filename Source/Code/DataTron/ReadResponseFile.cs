using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace DataTron
{
    class ReadResponseFile
    {
        public Node ReadResponseFileText()
        {
            string[] lines = File.ReadAllLines("DataGridResponseFile.txt");

            string clusterName = (Array.Find(lines, element => element.StartsWith("ClusterName ="))).Replace("ClusterName = ", "");
            string nodeName = (Array.Find(lines, element => element.StartsWith("NodeName = "))).Replace("NodeName = ", "");
            bool nodeMaster = Convert.ToBoolean(((Array.Find(lines, element => element.StartsWith("IsMaster ="))).Replace("UnicastHosts =", "IsMaster =")));
            bool nodeData = Convert.ToBoolean(((Array.Find(lines, element => element.StartsWith("IsData ="))).Replace("IsData =", "")));
            int minimumMasterNode = Convert.ToInt32(((Array.Find(lines, element => element.StartsWith("MasterNodeNumber = "))).Replace("MasterNodeNumber = ", "")));
            string unicastHosts = ((Array.Find(lines, element => element.StartsWith("UnicastHosts = "))).Replace("UnicastHosts = ", ""));
            
            bool destructiveRequiresName;
            bool autoCreateIndex;
            string monitoringNodeName;
            string dataPath;
            string pathRepository;
            string esUserName;
            string esPassWord;
            string authenticationWebServer;
            string serviceAccountUserName;
            string serviceAccountPassWord;

            Node Node1 = new Node(clusterName,nodeName,nodeMaster,nodeData,minimumMasterNode,unicastHosts,destructiveRequiresName,  autoCreateIndex,monitoringNodeName,dataPath,pathRepository,esUserName,esPassWord,authenticationWebServer,  serviceAccountUserName,serviceAccountPassWord);

            return Node1;
        }

        

    }
}
