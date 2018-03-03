using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace DataTron
{
    public partial class Form1 : Form
    {
        Node node = new Node();
        public Form1()
        {
            InitializeComponent();
            
        }

        private void btnForm1Next_Click(object sender, EventArgs e)
        {
            Form2 form2 = new Form2();
            form2.Tag = this;
            form2.Show(this);
            Hide();
        }

        private void btnCreateResponseFile_Click(object sender, EventArgs e)
        {
            try
            {
                CreateBlankResponseFile.MakeResponseFile();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }

            MessageBox.Show("Response File Created.", "Task Complete.");
        }

        private void btnLoadResponce_Click(object sender, EventArgs e)
        {
            LoadResponseFile.ReadResponseFileText(node);

            textBoxClusterName.Text = node.ClusterName;
            textBoxNodeName.Text = node.NodeName;
            textBoxMasterNode.Text = node.NodeMaster;
            textBoxDataNode.Text = node.NodeData;
            textBoxNumberMasters.Text = node.MinimumMasterNode;
            textBoxMonitorNode.Text = node.NodeMonitor;
            textBoxMonitoringNodeName.Text = node.MonitoringNodeName;
            textBoxDataPath.Text = node.DataPath;
            textBoxBackupLoc.Text = node.PathRepository;
            textBoxESUser.Text = node.EsUserName;
            textBoxESPassword.Text = node.EsPassWord;
            textBoxRelUser.Text = node.ServiceAccountUserName;
            textBoxRelPass.Text = node.ServiceAccountPassWord;
            textBoxUnicastHosts.Text = node.UnicastHosts;
        }

        private void textBoxClusterName_TextChanged(object sender, EventArgs e)
        {
            node.ClusterName = textBoxClusterName.Text;
        }

        private void textBoxNodeName_TextChanged(object sender, EventArgs e)
        {
            node.NodeName = textBoxClusterName.Text;
        }

        private void textBoxMasterNode_TextChanged(object sender, EventArgs e)
        {
            node.NodeMaster = textBoxMasterNode.Text;
        }

        private void textBoxDataNode_TextChanged(object sender, EventArgs e)
        {
            node.NodeData = textBoxDataNode.Text;
        }

        private void textBoxNumberMasters_TextChanged(object sender, EventArgs e)
        {
            node.MinimumMasterNode = textBoxNumberMasters.Text;
        }

        private void textBoxMonitorNode_TextChanged(object sender, EventArgs e)
        {
            node.NodeMonitor = textBoxMonitorNode.Text;
        }

        private void textBoxMonitoringNodeName_TextChanged(object sender, EventArgs e)
        {
            node.MonitoringNodeName = textBoxMonitoringNodeName.Text;
        }

        private void textBoxDataPath_TextChanged(object sender, EventArgs e)
        {
            node.DataPath = textBoxDataPath.Text;
        }

        private void textBoxBackupLoc_TextChanged(object sender, EventArgs e)
        {
            node.PathRepository = textBoxBackupLoc.Text;
        }

        private void textBoxESUser_TextChanged(object sender, EventArgs e)
        {
            node.EsUserName = textBoxESUser.Text;
        }

        private void textBoxESPassword_TextChanged(object sender, EventArgs e)
        {
            node.EsPassWord = textBoxESPassword.Text;
        }

        private void textBoxRelUser_TextChanged(object sender, EventArgs e)
        {
            node.ServiceAccountUserName = textBoxRelUser.Text;
        }

        private void textBoxRelPass_TextChanged(object sender, EventArgs e)
        {
            node.ServiceAccountPassWord = textBoxRelPass.Text;
        }

        private void textBoxUnicastHosts_TextChanged(object sender, EventArgs e)
        {
            node.UnicastHosts = textBoxUnicastHosts.Text;
        }

        private void btnUpdateResponse_Click(object sender, EventArgs e)
        {
            textBoxClusterName.Text = node.ClusterName;
            textBoxNodeName.Text = node.NodeName;
            textBoxMasterNode.Text = node.NodeMaster;
            textBoxDataNode.Text = node.NodeData;
            textBoxNumberMasters.Text = node.MinimumMasterNode;
            textBoxMonitorNode.Text = node.NodeMonitor;
            textBoxMonitoringNodeName.Text = node.MonitoringNodeName;
            textBoxDataPath.Text = node.DataPath;
            textBoxBackupLoc.Text = node.PathRepository;
            textBoxESUser.Text = node.EsUserName;
            textBoxESPassword.Text = node.EsPassWord;
            textBoxRelUser.Text = node.ServiceAccountUserName;
            textBoxRelPass.Text = node.ServiceAccountPassWord;
            textBoxUnicastHosts.Text = node.UnicastHosts;

            string[] lines = File.ReadAllLines("DataGridResponseFile.txt");
            lines = UpdateResponseFile.UpdateResponseFileText(node, "ClusterName = ", node.ClusterName, lines);

            File.WriteAllLines("DataGridResponseFile.txt", lines);
        }
    }
}
