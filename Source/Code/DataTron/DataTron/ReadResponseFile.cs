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


            string ParseResponseString(string StringToParse, string[] linesArray)
            {
                string ParsedResponce = (Array.Find(linesArray, element => element.StartsWith(StringToParse))).Replace(StringToParse, "");
                return ParsedResponce;
            }

            bool ParseResponseBool(string StringToParse, string[] linesArray)
            {
                bool ParsedResponce = Convert.ToBoolean(((Array.Find(linesArray, element => element.StartsWith(StringToParse))).Replace(StringToParse, "")));
                return ParsedResponce;
            }

            int ParseResponseInt(string StringToParse, string[] linesArray)
            {
                int ParsedResponce = Convert.ToInt32(((Array.Find(linesArray, element => element.StartsWith(StringToParse))).Replace(StringToParse, "")));
                return ParsedResponce;
            }

            string clusterName = ParseResponseString("ClusterName =", lines);
            bool nodeMaster = ParseResponseBool("IsMaster =", lines);
            bool nodeData = ParseResponseBool("IsData = ", lines);
            bool nodeMonitor = ParseResponseBool("IsMonitor = ", lines);
            int minimumMasterNode = ParseResponseInt("MasterNodeNumber = ", lines);
            string nodeName = ParseResponseString("NodeName = ", lines);          
            string unicastHosts = ParseResponseString("UnicastHosts = ", lines);
            string monitoringNodeName = ParseResponseString("MonitoringNodeName = ", lines);
            string dataPath = ParseResponseString("DataPath = ", lines);
            string pathRepository = ParseResponseString("PathRepository =", lines);
            string esUserName = ParseResponseString("EsUserName = ", lines);
            string esPassWord = ParseResponseString("EsPassWord = ", lines);
            string authenticationWebServer = ParseResponseString("AuthenticationWebServer = ", lines);
            string serviceAccountUserName = ParseResponseString("ServiceAccountUserName = ", lines);
            string serviceAccountPassWord = ParseResponseString("ServiceAccountUserName = ", lines);
            
            bool DestructionRequired()
            { 
                if (nodeMonitor)
                {
                    bool destruct = false;
                    return destruct;
                }
                else
                {
                    bool destruct = true;
                    return destruct;
                }

            }
            bool destructiveRequiresName = DestructionRequired();

            bool AutoCreateIndex()
            {
                if (nodeMonitor)
                {
                    bool autocreate = true;
                    return autocreate;
                }
                else
                {
                    bool autocreate = false;
                    return autocreate;
                }

            }
            bool autoCreateIndex = AutoCreateIndex();

            Node Node1 = new Node(clusterName, nodeName, nodeMaster, nodeData, minimumMasterNode, unicastHosts, destructiveRequiresName, autoCreateIndex, monitoringNodeName, dataPath, pathRepository, esUserName, esPassWord, authenticationWebServer, serviceAccountUserName, serviceAccountPassWord);

            return Node1;
        }
    }
}
