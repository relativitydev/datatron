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


            string ParseResponse(string StringToParse, string[] linesArray)
            {
                string ParsedResponce = (Array.Find(linesArray, element => element.StartsWith(StringToParse))).Replace(StringToParse, "");
                return ParsedResponce;
            }

            string clusterName = ParseResponse("ClusterName =", lines);
            string nodeMaster = ParseResponse("IsMaster =", lines);
            string nodeData = ParseResponse("IsData = ", lines);
            string nodeMonitor = ParseResponse("IsMonitor = ", lines);
            string minimumMasterNode = ParseResponse("MasterNodeNumber = ", lines);
            string nodeName = ParseResponse("NodeName = ", lines);          
            string unicastHosts = ParseResponse("UnicastHosts = ", lines);
            string monitoringNodeName = ParseResponse("MonitoringNodeName = ", lines);
            string dataPath = ParseResponse("DataPath = ", lines);
            string pathRepository = ParseResponse("PathRepository =", lines);
            string esUserName = ParseResponse("EsUserName = ", lines);
            string esPassWord = ParseResponse("EsPassWord = ", lines);
            string authenticationWebServer = ParseResponse("AuthenticationWebServer = ", lines);
            string serviceAccountUserName = ParseResponse("ServiceAccountUserName = ", lines);
            string serviceAccountPassWord = ParseResponse("ServiceAccountPassWord = ", lines);
            
            string DestructionRequired()
            { 
                if (Convert.ToBoolean(nodeMonitor))
                {
                    string destruct = "false";
                    return destruct;
                }
                else
                {
                    string destruct = "true";
                    return destruct;
                }

            }
            string destructiveRequiresName = DestructionRequired();

            string AutoCreateIndex()
            {
                if (Convert.ToBoolean(nodeMonitor))
                {
                    string autocreate = "true";
                    return autocreate;
                }
                else
                {
                    string autocreate = "false";
                    return autocreate;
                }

            }
            string autoCreateIndex = AutoCreateIndex();

            Node Node1 = new Node(clusterName, nodeName, nodeMaster, nodeData, nodeMonitor, minimumMasterNode, unicastHosts, destructiveRequiresName, autoCreateIndex, monitoringNodeName, dataPath, pathRepository, esUserName, esPassWord, authenticationWebServer, serviceAccountUserName, serviceAccountPassWord);

            return Node1;
        }
    }
}
