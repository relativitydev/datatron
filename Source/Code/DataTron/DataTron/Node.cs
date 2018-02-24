using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataTron
{
    public class Node
    {
        private string _clusterName;
        private string _nodeName;
        private string _nodeMaster;
        private string _nodeData;
        private string _minimumMasterNode;
        private string _unicastHosts;
        private string _destructiveRequiresName;
        private string _autoCreateIndex;
        private string _monitoringNodeName;
        private string _dataPath;
        private string _pathRepository;
        private string _esUserName;
        private string _esPassWord;
        private string _authenticationWebServer;
        private string _serviceAccountUserName;
        private string _serviceAccountPassWord;

        public Node(string clusterName, string nodeName, string nodeMaster, string nodeData, string minimumMasterNode, string unicastHosts, string destructiveRequiresName, string autoCreateIndex, string monitoringNodeName, string dataPath, string pathRepository, string esUserName, string esPassWord, string authenticationWebServer, string serviceAccountUserName, string serviceAccountPassWord)
        {
            ClusterName = clusterName;
            NodeName = nodeName;
            NodeMaster = nodeMaster;
            NodeData = nodeData;
            MinimumMasterNode = minimumMasterNode;
            UnicastHosts = unicastHosts;
            DestructiveRequiresName = destructiveRequiresName;
            AutoCreateIndex = autoCreateIndex;
            MonitoringNodeName = monitoringNodeName;
            DataPath = dataPath;
            PathRepository = pathRepository;
            EsUserName = esUserName;
            EsPassWord = esPassWord;
            AuthenticationWebServer = authenticationWebServer;
            ServiceAccountUserName = serviceAccountUserName;
            ServiceAccountPassWord = serviceAccountPassWord;
        }

        public string ClusterName { get => _clusterName; set => _clusterName = value; }
        public string NodeName { get => _nodeName; set => _nodeName = value; }
        public string NodeMaster { get => _nodeMaster; set => _nodeMaster = value; }
        public string NodeData { get => _nodeData; set => _nodeData = value; }
        public string MinimumMasterNode { get => _minimumMasterNode; set => _minimumMasterNode = value; }
        public string UnicastHosts { get => _unicastHosts; set => _unicastHosts = value; }
        public string DestructiveRequiresName { get => _destructiveRequiresName; set => _destructiveRequiresName = value; }
        public string AutoCreateIndex { get => _autoCreateIndex; set => _autoCreateIndex = value; }
        public string MonitoringNodeName { get => _monitoringNodeName; set => _monitoringNodeName = value; }
        public string DataPath { get => _dataPath; set => _dataPath = value; }
        public string PathRepository { get => _pathRepository; set => _pathRepository = value; }
        public string EsUserName { get => _esUserName; set => _esUserName = value; }
        public string EsPassWord { get => _esPassWord; set => _esPassWord = value; }
        public string AuthenticationWebServer { get => _authenticationWebServer; set => _authenticationWebServer = value; }
        public string ServiceAccountUserName { get => _serviceAccountUserName; set => _serviceAccountUserName = value; }
        public string ServiceAccountPassWord { get => _serviceAccountPassWord; set => _serviceAccountPassWord = value; }
    }
}
