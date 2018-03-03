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
        private string _nodeMonitor;
        private string _minimumMasterNode;
        private string _unicastHosts;
        private string _destructiveRequiresName;
        private string _autoCreateIndex;
        private string _monitoringNode;
        private string _dataPath;
        private string _pathRepository;
        private string _esUserName;
        private string _esPassWord;
        private string _authenticationWebServer;
        private string _serviceAccountUserName;
        private string _serviceAccountPassWord;


        public string NodeMonitor { get => _nodeMonitor; set => _nodeMonitor = value; }
        public string ClusterName { get => _clusterName; set => _clusterName = value; }
        public string NodeName { get => _nodeName; set => _nodeName = value; }
        public string NodeMaster { get => _nodeMaster; set => _nodeMaster = value; }
        public string NodeData { get => _nodeData; set => _nodeData = value; }
        public string MinimumMasterNode { get => _minimumMasterNode; set => _minimumMasterNode = value; }
        public string UnicastHosts { get => _unicastHosts; set => _unicastHosts = value; }
        public string MonitoringNode { get => _monitoringNode; set => _monitoringNode = value; }
        static string DestructionRequired(string NodeMonitor)
        {
            if (Convert.ToBoolean(NodeMonitor))
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
        static string AutoCreateIndexSetting(string NodeMonitor)
        {
            if (Convert.ToBoolean(NodeMonitor))
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
        public string DataPath { get => _dataPath; set => _dataPath = value; }
        public string PathRepository { get => _pathRepository; set => _pathRepository = value; }
        public string EsUserName { get => _esUserName; set => _esUserName = value; }
        public string EsPassWord { get => _esPassWord; set => _esPassWord = value; }
        public string AuthenticationWebServer { get => _authenticationWebServer; set => _authenticationWebServer = value; }
        public string ServiceAccountUserName { get => _serviceAccountUserName; set => _serviceAccountUserName = value; }
        public string ServiceAccountPassWord { get => _serviceAccountPassWord; set => _serviceAccountPassWord = value; }
        public string DestructiveRequiresName { get => _destructiveRequiresName; set => _destructiveRequiresName = DestructionRequired(NodeMonitor); }
        public string AutoCreateIndex { get => _autoCreateIndex; set => _autoCreateIndex = AutoCreateIndexSetting(NodeMonitor); }
  
    }
}
