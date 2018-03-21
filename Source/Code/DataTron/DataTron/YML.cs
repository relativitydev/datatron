using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataTron
{
    class YML
    {
        public string PopulateTheYML(string ClusterName, string NodeName, string NodeMaster, string NodeData, string UnicastHosts, string NodeMonitor, string MonitoringNode, string DataPath, string PathRepository, string WebServer, string NumberOfMasters, string MarvelUser, string MarvelPass)
        {
            if (MonitoringNode != null & MonitoringNode != "")
            {
                MonitoringNode = MonitoringNode.Replace($@"{MonitoringNode}", $@"[""http://{MonitoringNode}:9200""]");
            }

            string Auto;
            string Destructive;

            if (NodeMonitor == "true")
            {
                Destructive = "false";
                Auto = "true";
            }
            else
            {
                Destructive = "true";
                Auto = "false,.security";
            }

            //Format UnicastHosts
            UnicastHosts = UnicastHosts.Insert(0, @"[""").Insert(UnicastHosts.Length + 2, @"""]").Replace(",", @""",""");

            //Format PathRepository
            if (string.IsNullOrEmpty(PathRepository))
            {
                PathRepository = "#path.repo: ";
            }
            else
            {
                PathRepository = PathRepository.Insert(0, @"[""").Insert(PathRepository.Length + 2, @"""]").Replace(@"\", @"\\");
                PathRepository = "path.repo: " + PathRepository;
            }
            //Format number of Masters

            if (decimal.TryParse(NumberOfMasters, out decimal DecofMasters))
            {
                NumberOfMasters = (Math.Floor((DecofMasters / 2) + 1)).ToString();
            }

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
  auth: 
   username: {MarvelUser}
   password: {MarvelPass}

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
{PathRepository}

# This disables the Java security manager - plugins cannot specify their own
# security policies in this version of ES and will not function properly
security.manager.enabled: false

#network settings
network.host: {NodeName}

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
  publicJWKsUrl: https://{WebServer}/Relativity/Identity/.well-known/jwks
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
            if (string.IsNullOrEmpty(MonitoringNode) || NodeMonitor == "true")
            {
                string defaultMarvelSetting = $@"marvel.agent.exporters:
 id1:
  type: http
  host: {MonitoringNode}
  auth: 
   username: {MarvelUser}
   password: {MarvelPass}";
                string commentOutMarvelSetting = $@"marvel.enabled: false
#marvel.agent.exporters:
# id1:
#  type: http
#  host: {MonitoringNode}
#  auth: 
#   username: {MarvelUser}
#   password: {MarvelPass}";

                yml = yml.Replace(defaultMarvelSetting, commentOutMarvelSetting);
            }

            if (NodeMonitor == "true")
            {
                string defaultShieldSettings = $@"shield.authc.realms: 
 custom:
  type: kCuraBearerRealm
  order: 0
  publicJWKsUrl: https://{WebServer}/Relativity/Identity/.well-known/jwks
 esusers1:
  type: esusers
  order: 1";
                string removeThePublicJWKsUrl = $@"shield.authc.realms: 
 esusers1:
  type: esusers
  order: 0";
                yml = yml.Replace(defaultShieldSettings, removeThePublicJWKsUrl);
            }

            return yml;
            #endregion
        }
    }
}
