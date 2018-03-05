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


            void Copy(string sourceDirectory, string targetDirectory)
            {
                DirectoryInfo diSource = new DirectoryInfo(sourceDirectory);
                DirectoryInfo diTarget = new DirectoryInfo(targetDirectory);

                CopyAll(diSource, diTarget);
            }

            void CopyAll(DirectoryInfo source, DirectoryInfo target)
            {
                Directory.CreateDirectory(target.FullName);

                // Copy each file into the new directory.
                foreach (FileInfo fi in source.GetFiles())
                {
                    Console.WriteLine(@"Copying {0}\{1}", target.FullName, fi.Name);
                    fi.CopyTo(Path.Combine(target.FullName, fi.Name), true);
                }

                // Copy each subdirectory using recursion.
                foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
                {
                    DirectoryInfo nextTargetSubDir =
                        target.CreateSubdirectory(diSourceSubDir.Name);
                    CopyAll(diSourceSubDir, nextTargetSubDir);
                }
            }

            Copy("RelativityDataGrid", installPath + "\\RelativityDataGridTest");


            MessageBox.Show("Created the package at " + installPath);
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
            YML yml = new YML();
            string message = yml.PopulateTheYML(node.ClusterName, node.NodeName, node.NodeMaster, node.NodeData, node.UnicastHosts, node.NodeMonitor, node.MonitoringNode, node.DataPath, node.PathRepository, node.AutoCreateIndex, node.MinimumMasterNode);
            RunLog runLog = new RunLog(); runLog.Frogger(message);
            MessageBox.Show("yml file updated.");
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
