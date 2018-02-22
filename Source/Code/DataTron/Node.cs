using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataTron
{
    class Node
    {
        private string _clusterName;
        private string _nodeName;
        private bool _nodeMaster;
        private bool _nodeData;
        private short _minimumMasterNode;
        private Array _unicastHosts;
        private bool _destructiveRequiresName;
        private bool _autoCreateIndex;
        private string _monitoringNodeName;
        private string _dataPath;
        private string _pathRepository;
        private string _esUserName;
        private string _esPassWord;
        private string _authenticationWebServer;
        private string _serviceAccountUserName;
        private string _serviceAccountPassWord;

        public string ClusterName { get => _clusterName; set => _clusterName = value; }
        public string NodeName { get => _nodeName; set => _nodeName = value; }
        public bool NodeMaster { get => _nodeMaster; set => _nodeMaster = value; }
        public bool NodeData { get => _nodeData; set => _nodeData = value; }
        public short MinimumMasterNode { get => _minimumMasterNode; set => _minimumMasterNode = value; }
        public Array UnicastHosts { get => _unicastHosts; set => _unicastHosts = value; }
        public bool DestructiveRequiresName { get => _destructiveRequiresName; set => _destructiveRequiresName = value; }
        public bool AutoCreateIndex { get => _autoCreateIndex; set => _autoCreateIndex = value; }
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
