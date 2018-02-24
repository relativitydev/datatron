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
            ReadResponseFile responseFile = new ReadResponseFile();
            Node Node1 = responseFile.ReadResponseFileText();

            textBoxClusterName.Text = Node1.ClusterName;
            textBoxNodeName.Text = Node1.NodeName;
            textBoxMasterNode.Text = Node1.NodeMaster;
            textBoxDataNode.Text = Node1.NodeData;
            textBoxNumberMasters.Text = Node1.MinimumMasterNode;
            textBoxMonitorNode.Text = Node1.NodeMonitor;
            textBoxMonitoringNodeName.Text = Node1.MonitoringNodeName;
            textBoxDataPath.Text = Node1.DataPath;
            textBoxBackupLoc.Text = Node1.PathRepository;
            textBoxESUser.Text = Node1.EsUserName;
            textBoxESPassword.Text = Node1.EsPassWord;
            textBoxRelUser.Text = Node1.ServiceAccountUserName;
            textBoxRelPass.Text = Node1.ServiceAccountPassWord;



        }
    }
}
