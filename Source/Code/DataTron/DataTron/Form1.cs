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
using System.Runtime.InteropServices;

[ComVisibleAttribute(true)]
public enum UIPermissionWindow { AllWindows }

namespace DataTron
{
    public partial class Form1 : Form
    {
        public Node node = new Node();
        public Form1()
        {
            InitializeComponent();
            
        }

        void PopulateNodeWithTextBoxValues()
        {
            textBoxClusterName.Text = node.ClusterName;
            textBoxNodeName.Text = node.NodeName;
            textBoxMasterNode.Text = node.NodeMaster;
            textBoxDataNode.Text = node.NodeData;
            textBoxNumberMasters.Text = node.MinimumMasterNode;
            textBoxMonitorNode.Text = node.NodeMonitor;
            textBoxMonitoringNode.Text = node.MonitoringNode;
            textBoxDataPath.Text = node.DataPath;
            textBoxBackupLoc.Text = node.PathRepository;
            textBoxESUser.Text = node.EsUserName;
            textBoxESPassword.Text = node.EsPassWord;
            textBoxRelUser.Text = node.ServiceAccountUserName;
            textBoxRelPass.Text = node.ServiceAccountPassWord;
            textBoxUnicastHosts.Text = node.UnicastHosts;
            textBoxAuthWebServer.Text = node.AuthenticationWebServer;
        }

        private void btnForm1Next_Click(object sender, EventArgs e)
        {
            Form2 form2 = new Form2();
            form2.Tag = this;
            form2.node = node;
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

            PopulateNodeWithTextBoxValues();

            MessageBox.Show("Response File Loaded.");
        }

        private void checkBoxNoResponseFile_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBoxNoResponseFile.Checked)
            {
                PopulateNodeWithTextBoxValues();

                MessageBox.Show("Values loaded to memory, No reponse file created.");
            }
        }

        #region //Event Handlers for Text Box changes
        private void textBoxClusterName_TextChanged(object sender, EventArgs e)
        {
            node.ClusterName = textBoxClusterName.Text;
        }

        private void textBoxNodeName_TextChanged(object sender, EventArgs e)
        {
            node.NodeName = textBoxNodeName.Text;
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

        private void textBoxMonitoringNode_TextChanged(object sender, EventArgs e)
        {
            node.MonitoringNode = textBoxMonitoringNode.Text;
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

        private void textBoxAuthWebServer_TextChanged(object sender, EventArgs e)
        {
            node.AuthenticationWebServer = textBoxAuthWebServer.Text;
        }

        private void btnUpdateResponse_Click(object sender, EventArgs e)
        {
            string[] lines = File.ReadAllLines("DataGridResponseFile.txt");

            lines = UpdateResponseFile.UpdateResponseFileText(node, "ClusterName = ", textBoxClusterName.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "NodeName = ", textBoxNodeName.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "UnicastHosts = ", textBoxUnicastHosts.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "IsMaster = ", textBoxMasterNode.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "IsData = ", textBoxDataNode.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "IsMonitor = ", textBoxMonitorNode.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "MasterNodeNumber = ", textBoxNumberMasters.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "MonitoringNode = ", textBoxMonitoringNode.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "DataPath = ", textBoxDataPath.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "PathRepository = ", textBoxBackupLoc.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "EsUserName = ", textBoxESUser.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "EsPassWord = ", textBoxESPassword.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "AuthenticationWebServer = ", textBoxAuthWebServer.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "ServiceAccountUserName = ", textBoxRelUser.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            lines = UpdateResponseFile.UpdateResponseFileText(node, "ServiceAccountPassWord = ", textBoxRelPass.Text, lines);
            File.WriteAllLines("DataGridResponseFile.txt", lines);
            LoadResponseFile.ReadResponseFileText(node);

            MessageBox.Show("Response File Updated.");
        }

        #endregion

        private void Form1_Load(object sender, EventArgs e)
        {
            ToolTip toolTip = new ToolTip();

            toolTip.AutoPopDelay = 5000;
            toolTip.InitialDelay = 100;
            toolTip.ReshowDelay = 500;

            toolTip.SetToolTip(textBoxClusterName, "Enter a clustername, do not use special characters.");
            toolTip.SetToolTip(textBoxNodeName, "Enter the FQDN name of this node.");
        }

        private void checkBoxMasterRole_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBoxMasterRole.Checked)
            {
                textBoxMasterNode.Text = "true";
            }
            if (!checkBoxMasterRole.Checked)
            {
                textBoxMasterNode.Text = "false";
            }
        }

        private void checkBoxDataRole_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBoxDataRole.Checked)
            {
                textBoxDataNode.Text = "true";
            }
            if (!checkBoxDataRole.Checked)
            {
                textBoxDataNode.Text = "false";
            }
        }

        private void checkMonitorRole_CheckedChanged(object sender, EventArgs e)
        {
            if (checkMonitorRole.Checked)
            {
                textBoxMonitoringNode.Text = "true";
            }
            if (!checkMonitorRole.Checked)
            {
                textBoxMonitoringNode.Text = "false";
            }
        }

        private void textBoxDataPath_DoubleClick(object sender, EventArgs e)
        {
            FolderBrowserDialog DialogBox = new FolderBrowserDialog();
            DialogBox.ShowDialog();
            textBoxDataPath.Text = DialogBox.SelectedPath;
            DialogBox.Dispose();
        }

        private void textBoxNodeName_ControlAdded(object sender, ControlEventArgs e)
        {
            textBoxNodeName.Text = Environment.MachineName;
        }
    }
}
