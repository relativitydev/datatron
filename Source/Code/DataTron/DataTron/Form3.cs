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
            Application.Exit();
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

        private void buttonBack_Click_1(object sender, EventArgs e)
        {
            var form2 = (Form2)Tag;
            Hide();
            form2.Show();
        }

        private void Form3_FormClosed(object sender, FormClosedEventArgs e)
        {
            var form2 = (Form2)Tag;
            Hide();
            form2.Show();
        }

        private void buttonSnapshot_Click(object sender, EventArgs e)
        {
            string timeInTicks = (DateTime.Now).Ticks.ToString();
            Uri snapshotUri = new Uri($@"http://{node.NodeName}:9200/_snapshot/datagridbackup/{timeInTicks}");
            string repoPathJava = node.PathRepository.Replace(@"\", @"/");
            string body = $@"";
            string YouKnowForSearch = RESTRequest.putRequest(snapshotUri, node.EsUserName, node.EsPassWord, body);
            MessageBox.Show(YouKnowForSearch);
        }

        private void buttonKibanaTemplate_Click(object sender, EventArgs e)
        {
            Uri kibanaTemplateUri = new Uri($@"http://{node.NodeName}:9200/_template/custom_kibana");
            string body = $@"{{ ""template"": "".kibana*"", ""order"": 1, ""settings"": {{ ""number_of_shards"": 1, ""number_of_replicas"": 0 }} }}";
            string YouKnowForSearch = RESTRequest.putRequest(kibanaTemplateUri, node.EsUserName, node.EsPassWord, body);
            MessageBox.Show(YouKnowForSearch);
        }

        private void buttonMarvelTemplate_Click(object sender, EventArgs e)
        {
            Uri marvelTemplateUri = new Uri($@"http://{node.NodeName}:9200/_template/custom_marvel");
            string body = $@"{{ ""template"": "".marvel*"", ""order"": 1, ""settings"": {{ ""number_of_shards"": 1, ""number_of_replicas"": 0 }} }}";
            string YouKnowForSearch = RESTRequest.putRequest(marvelTemplateUri, node.EsUserName, node.EsPassWord, body);
            MessageBox.Show(YouKnowForSearch);
        }
    }
}
