using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DataTron
{
    public partial class Form3 : Form
    {
        public Node node { get; internal set; }


        public Form3()
        {
            InitializeComponent();

        }


        private void buttonBack_Click(object sender, EventArgs e)
        {

        }

        private void buttonTestNode_Click(object sender, EventArgs e)
        {
            Uri helloUri = new Uri($@"http://{node.NodeName}:9200");
            string YouKnowForSearch = RESTRequest.getRequest(helloUri, node.EsUserName, node.EsPassWord);

            MessageBox.Show(YouKnowForSearch);
        }

        private void buttonGetLicense_Click(object sender, EventArgs e)
        {
            Uri LicenseUri = new Uri($@"http://{node.NodeName}:9200/_license");
            string YouKnowForSearch = RESTRequest.getRequest(LicenseUri, node.EsUserName, node.EsPassWord);

            MessageBox.Show(YouKnowForSearch);
        }

        private void buttonUpdateLicense_Click(object sender, EventArgs e)
        {
            Uri LicenseUri = new Uri($@"http://{node.NodeName}:9200/_license");
            try
            {
                string body = File.ReadAllText("license.json");
                string YouKnowForSearch = RESTRequest.putRequest(LicenseUri, node.EsUserName, node.EsPassWord, body);
                MessageBox.Show(YouKnowForSearch);
            }
            catch (FileNotFoundException)
            {
                MessageBox.Show("Did not find a license.json file.");
            }
        }

        private void buttonGetSnapshot_Click(object sender, EventArgs e)
        {
            Uri snapshotUri = new Uri($@"http://{node.NodeName}:9200/_snapshot");
            string YouKnowForSearch = RESTRequest.getRequest(snapshotUri, node.EsUserName, node.EsPassWord);

            if (YouKnowForSearch == "{}")
            {
                MessageBox.Show("No snapshot area registered.");
            }
            else
            {
                MessageBox.Show(YouKnowForSearch);
            }
        }

        private void buttonRegisterSnapShot_Click(object sender, EventArgs e)
        {
            Uri snapshotUri = new Uri($@"http://{node.NodeName}:9200/_snapshot/datagridbackup");
            string repoPathJava = node.PathRepository.Replace(@"\", @"/");
            string body = $@"{{ ""type"": ""fs"", ""settings"": {{ ""location"": ""{repoPathJava}"", ""compress"": true}} }}";
            string YouKnowForSearch = RESTRequest.putRequest(snapshotUri, node.EsUserName, node.EsPassWord, body);

            MessageBox.Show(YouKnowForSearch);
        }
    }
}
