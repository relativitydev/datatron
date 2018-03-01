using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

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

        }
    }
}
