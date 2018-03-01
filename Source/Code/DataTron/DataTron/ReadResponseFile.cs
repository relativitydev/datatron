using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace DataTron
{
    class LoadResponseFile
    {
        public static void ReadResponseFileText(Node node)
        {
            string[] lines = File.ReadAllLines("DataGridResponseFile.txt");

            //TODO make sure there are no begin or trailing spaces.  Use a regex?

            string ParseResponse(string StringToParse, string[] linesArray)
            {
                string ParsedResponce = (Array.Find(linesArray, element => element.StartsWith(StringToParse))).Replace(StringToParse, "");
                return ParsedResponce;
            }

            node.ClusterName = ParseResponse("ClusterName =", lines);
            node.NodeMaster = ParseResponse("IsMaster =", lines);
            node.NodeData = ParseResponse("IsData = ", lines);
            node.NodeMonitor = ParseResponse("IsMonitor = ", lines);
            node.MinimumMasterNode = ParseResponse("MasterNodeNumber = ", lines);
            node.NodeMonitor = ParseResponse("NodeName = ", lines);          
            node.UnicastHosts = ParseResponse("UnicastHosts = ", lines);
            node.MonitoringNodeName = ParseResponse("MonitoringNodeName = ", lines);
            node.DataPath = ParseResponse("DataPath = ", lines);
            node.PathRepository= ParseResponse("PathRepository =", lines);
            node.EsUserName = ParseResponse("EsUserName = ", lines);
            node.EsPassWord = ParseResponse("EsPassWord = ", lines);
            node.AuthenticationWebServer = ParseResponse("AuthenticationWebServer = ", lines);
            node.ServiceAccountUserName = ParseResponse("ServiceAccountUserName = ", lines);
            node.ServiceAccountUserName = ParseResponse("ServiceAccountPassWord = ", lines);

        
        }
    }
}
