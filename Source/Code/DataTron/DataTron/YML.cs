using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataTron
{
    class YML
    {
        public string PopulateTheYML(string ClusterName, string NodeName, string NodeMaster, string NodeData, string UnicastHosts, string NodeMonitor, string MonitoringNode, string DataPath, string PathRepository, string WebServer, string NumberOfMasters)
        {
            //Create settings for Action DestructiveRequiresName and AutoCreateIndexes
            if (NodeMonitor == null | NodeMonitor == "")
            {
                NodeMonitor = "false";
            }


            bool IsMonitoringNodeNull()
            {
                bool choice;
                if (MonitoringNode == null)
                {
                    choice = false;
                }
                else
                {
                    choice = true;
                }
                return choice;
            }
            bool MonitoringNodeExists = IsMonitoringNodeNull();


            string DestructiveAction()
            {
                string DA;
                if (MonitoringNodeExists)
                {
                    if (Convert.ToBoolean(NodeMonitor))
                    {
                        DA = "false";
                    }
                    else
                    {
                        DA = "true";
                    }
                }
                else
                {
                    DA = "true";
                }
                return DA;
            }

            string AutoCreateIndexes()
            {
                string ACI;
                if (MonitoringNodeExists)
                {
                    if (Convert.ToBoolean(NodeMonitor))
                    {
                        ACI = "true";
                    }
                    else
                    {
                        ACI = "false,.security";
                    }
                }
                else
                {
                    ACI = "false,.security";
                }
                return ACI;
            }

            string Auto = AutoCreateIndexes();
            string Destructive = DestructiveAction();


            //Format UnicastHosts
            UnicastHosts = UnicastHosts.Insert(0, @"""[""").Insert(UnicastHosts.Length + 3, @"""]""").Replace(",", @""",""");

            #region //YML string
            string yml = $@"
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please see the documentation for further information on configuration options:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration.html>
#
# ------------------------------- KCURA SETTINGS -------------------------------
cluster.name: {ClusterName}
#node name must be the FQDN
node.name: {NodeName}
node.master: {NodeMaster}
node.data: {NodeData}
discovery.zen.minimum_master_nodes: {NumberOfMasters}
discovery.zen.ping.multicast.enabled: false
discovery.zen.ping.unicast.hosts: {UnicastHosts}
# This prevents destructive actions w/ wildcards Ex: DELETE /*
action.destructive_requires_name: {Destructive}
# This disables automatic index creation
action.auto_create_index: {Auto}
# This is for global cluster state file to be readable
format: json
# This is an optimization that seems to work for our application
transport.tcp.compress: true
http.max_content_length: 201mb
http.cors.enabled: false

#This delays cluster recovery, providing additional time for all nodes to first come online
gateway.expected_master_nodes: 0
gateway.expected_data_nodes: 0
gateway.recover_after_time: 5m

marvel.agent.exporters:
 id1:
  type: http
  host: {MonitoringNode}

# This puts all scripting functionality in a sandbox
#script.disable_dynamic: true
script.inline: on
script.indexed: on
script.default_lang: groovy
script.groovy.sandbox.enabled: true

# Path to directory where to store index data allocated for this node.
path.data: {DataPath}

# Path to directory where to store backups
#path.repo: C:\RelativityDataGrid\backups
#path.repo: [""/mount/backups"", ""/mount/longterm_backups""]
#path.repo: {PathRepository}

# This disables the Java security manager - plugins cannot specify their own
# security policies in this version of ES and will not function properly
security.manager.enabled: false

#network settings
network.host: 

#set index result size - default is 10000
index.max_result_window: 2147483647

#---------------------- KCURA SHIELD SETTINGS----------------------------
#shield.enabled: false
#shield.audit.enabled: true
#sqlserver_whitelist: 
cache.expire: 10

shield.authc.realms: 
 custom:
  type: kCuraBearerRealm
  order: 0
  publicJWKsUrl: {WebServer}
 esusers1:
  type: esusers
  order: 1
  
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
# cluster.name: my-application
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
# node.name: node-1
#
# Add custom attributes to the node:
#
# node.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
# path.data: /path/to/data
#
# Path to log files:
#
# path.logs: /path/to/logs
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
# bootstrap.mlockall: true
#
# Make sure that the `ES_HEAP_SIZE` environment variable is set to about half the memory
# available on the system and that the owner of the process is allowed to use this limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
# network.host: 192.168.0.1
#
# Set a custom port for HTTP:
#
# http.port: 9200
#
# For more information, see the documentation at:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html>
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
# gateway.recover_after_nodes: 3
#
# For more information, see the documentation at:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-gateway.html>
#
# --------------------------------- Discovery ----------------------------------
#
# Elasticsearch nodes will find each other via unicast, by default.
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is [""127.0.0.1"", ""[::1]""]
#
# discovery.zen.ping.unicast.hosts: [""host1"", ""host2""]
#
# Prevent the ""split brain"" by configuring the majority of nodes (total number of nodes / 2 + 1):
#
# discovery.zen.minimum_master_nodes: 3
#
# For more information, see the documentation at:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery.html>
#
# ---------------------------------- Various -----------------------------------
#
# Disable starting multiple nodes on a single system:
#
# node.max_local_storage_nodes: 1
#
# Require explicit names when deleting indices:
#
# action.destructive_requires_name: true

";
            return yml;
            #endregion
        }

        public YML(string ClusterName, string NodeName, string NodeMaster, string NodeData, string UnicastHosts, string NodeMonitor, string MonitoringNode, string DataPath, string PathRepository, string WebServer, string NumberOfMasters)
        {

                ClusterName = "unspecified";
                NodeName = "default";
                NodeData = "true";
                UnicastHosts = "unspecified";
                NodeMonitor = "false";
                MonitoringNode = "unspecified";
                DataPath = @"c:\data";
                PathRepository = "";
                WebServer = "RelativityWebServer";
                NumberOfMasters = "1";

        }
    }
}
