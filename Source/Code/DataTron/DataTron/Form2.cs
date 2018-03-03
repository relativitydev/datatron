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
    public partial class Form2 : Form
    {
        public Node node { get; internal set; }

        public Form2()
        {
            InitializeComponent();
  
        }



        private void btnForm2Back_Click(object sender, EventArgs e)
        {
            var form1 = (Form1)Tag;
            form1.Show();
            Close();          
        }

        private void btnCopyPackage_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog DialogBox = new FolderBrowserDialog();
            DialogBox.ShowDialog();
            string installPath = DialogBox.SelectedPath;
            MessageBox.Show("You choose " + installPath);
            
        }

        private void btnSetJavaHeap_Click(object sender, EventArgs e)
        {

        }

        private void btnInstallJava_Click(object sender, EventArgs e)
        {

        }

        private void btnGetJavaHome_Click(object sender, EventArgs e)
        {
            string JavaHome = Environment.GetEnvironmentVariable("KCURA_JAVA_HOME");
            textBoxJavaHome.Text = JavaHome.Replace("\\\\","\\");
        }

        private void btnSetJavaHome_Click(object sender, EventArgs e)
        {

        }

        private void btnInstalWebCert_Click(object sender, EventArgs e)
        {

        }

        private void btnUpdateYML_Click(object sender, EventArgs e)
        {

        }

        private void btnInstallService_Click(object sender, EventArgs e)
        {

        }

        private void btnCreateEsUsers_Click(object sender, EventArgs e)
        {

        }

        private void Form2_FormClosed(object sender, FormClosedEventArgs e)
        {
            var form1 = (Form1)Tag;
            form1.Show();
            form1.Dispose();
        }
    }
}
