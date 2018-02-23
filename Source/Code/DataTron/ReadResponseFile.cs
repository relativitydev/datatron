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
            int minimumMasterNode = ParseResponseInt("MasterNodeNumber = ", lines);
            string nodeName = ParseResponseString("NodeName = ", lines);
            bool nodeData = ParseResponseBool("IsData = ", lines);
            string unicastHosts = ParseResponseString("UnicastHosts = ", lines);
            string monitoringNodeName = ParseResponseString("MonitoringNodeName = ", lines);
            //Work on assigning these correctly

            bool destructiveRequiresName = true;
            bool autoCreateIndex = false;

            //string monitoringNodeName = ((Array.Find(lines, element => element.StartsWith("MonitoringNodeName = "))).Replace("MonitoringNodeName = ", ""));
            string dataPath = ((Array.Find(lines, element => element.StartsWith("DataPath = "))).Replace("DataPath = ", ""));
            string pathRepository = ((Array.Find(lines, element => element.StartsWith("PathRepository ="))).Replace("PathRepository =", ""));
            string esUserName = ((Array.Find(lines, element => element.StartsWith("EsUserName ="))).Replace("EsUserName =", ""));
            string esPassWord;
            string authenticationWebServer;
            string serviceAccountUserName;
            string serviceAccountPassWord;

            Node Node1 = new Node(clusterName,nodeName,nodeMaster,nodeData,minimumMasterNode,unicastHosts,destructiveRequiresName,  autoCreateIndex,monitoringNodeName,dataPath,pathRepository,esUserName,esPassWord,authenticationWebServer,  serviceAccountUserName,serviceAccountPassWord);

            return Node1;
        }

        

    }
}
