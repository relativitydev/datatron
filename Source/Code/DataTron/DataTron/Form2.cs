using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.ServiceProcess;
using System.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Runtime.InteropServices;




namespace DataTron
{
    public partial class Form2 : Form
    {
        public Node node { get; internal set; }

        public Form2()
        {
            InitializeComponent();
  
        }
        public string installPath;
        X509Certificate2 certificate = new X509Certificate2();
        public static string driveLetter = (AppDomain.CurrentDomain.BaseDirectory).Split(':').GetValue(0).ToString();

        

        private void btnForm2Back_Click(object sender, EventArgs e)
        {
            var form1 = (Form1)Tag;
            Hide();
            form1.Show();
        }

        private void btnCopyPackage_Click(object sender, EventArgs e)
        {
            if (!Directory.Exists("RelativityDataGrid"))
            {
                MessageBox.Show("Please Copy the RelativityDataGrid Folder to the executable folder.", "RelativityDataGrid Package not found!");
            }
            else
            {
                FolderBrowserDialog DialogBox = new FolderBrowserDialog();
                DialogBox.ShowDialog();
                string installPath = DialogBox.SelectedPath;

                if (Directory.Exists($@"{installPath}/RelativityDataGrid"))
                {
                    MessageBox.Show("The RelativityDataGrid folders already exists!");
                }
                else
                {
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
                            fi.CopyTo(Path.Combine(target.FullName, fi.Name), true);
                        }

                        // Copy each subdirectory using recursion.
                        foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
                        {
                            DirectoryInfo nextTargetSubDir = target.CreateSubdirectory(diSourceSubDir.Name);
                            CopyAll(diSourceSubDir, nextTargetSubDir);
                        }
                    }

                    Copy("RelativityDataGrid", installPath + @"\RelativityDataGrid");

                    MessageBox.Show("Created the package at " + installPath);
                }
            }
        }

        private void btnSetJavaHeap_Click(object sender, EventArgs e)
        {

        }

        private void btnCheckJava_Click(object sender, EventArgs e)
        {

            string[] message = Directory.GetDirectories($@"{driveLetter}:\Program Files\Java", "jdk*");
            
            for(int x = 0; x < message.Length; x++)
            {
                listBoxJava.Items.Add(message[x]);
            }
            
        }

        private void btnGetJavaHome_Click(object sender, EventArgs e)
        {
            string JavaHome = Environment.GetEnvironmentVariable("KCURA_JAVA_HOME", EnvironmentVariableTarget.Machine);
            textBoxJavaHome.Text = JavaHome.Replace("\\\\","\\").Replace(@"/",@"\");
        }

        private void btnSetJavaHome_Click(object sender, EventArgs e)
        {
            Environment.SetEnvironmentVariable("KCURA_JAVA_HOME", textBoxJavaHome.Text, EnvironmentVariableTarget.Machine);
            MessageBox.Show($@"The environmental variable KCURA_JAVA_HOME set to {textBoxJavaHome.Text}");
        }

        private void btnInstalWebCert_Click(object sender, EventArgs e)
        {

            var processInfo = new ProcessStartInfo($@"{textBoxJavaHome.Text}\bin\keytool.exe", $@"-importcert -alias shield -keystore ""{textBoxJavaHome.Text}\jre\lib\security\cacerts"" -storepass changeit -file ShieldCert.pem -noprompt");

            var process = Process.Start(processInfo);

            process.OutputDataReceived += (object psender, DataReceivedEventArgs ev) =>
                MessageBox.Show(process.StandardOutput.ToString());

            process.WaitForExit();
            process.Close();
        }

        private void btnUpdateYML_Click(object sender, EventArgs e)
        {
            YML yml = new YML();

            string message = yml.PopulateTheYML(node.ClusterName, node.NodeName, node.NodeMaster, node.NodeData, node.UnicastHosts, node.NodeMonitor, node.MonitoringNode, node.DataPath, node.PathRepository, node.AuthenticationWebServer, node.MinimumMasterNode);

            File.WriteAllText(this.installPath + @"\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml", message);

            MessageBox.Show($@"yml file created at: {this.installPath}\RelativityDataGrid\elasticsearch-main\config\elasticsearch.yml");
        }
       
        private void btnInstallService_Click(object sender, EventArgs e)
        {
            ServiceController[] allServices = ServiceController.GetServices();
            bool elasticIsInstalled = false;
            foreach (ServiceController service in allServices)
            {
                if (service.ServiceName == "elasticsearch-service-x64")
                {
                    elasticIsInstalled = true;
                    MessageBox.Show("The elasticsearch service is already installed.");
                }
            }

            if (!elasticIsInstalled)
            {
                var processInfo = new ProcessStartInfo($@"{installPath}/RelativityDataGrid/elasticsearch-main/bin/kservice.bat", "install");

                processInfo.CreateNoWindow = true;
                processInfo.UseShellExecute = false;
                processInfo.RedirectStandardError = true;
                processInfo.RedirectStandardOutput = true;

                var process = Process.Start(processInfo);

                process.OutputDataReceived += (object psender, DataReceivedEventArgs ev) =>
                    MessageBox.Show("output>>" + ev.Data);
                process.BeginOutputReadLine();

                process.ErrorDataReceived += (object psender, DataReceivedEventArgs ev) =>
                    MessageBox.Show("error>>" + ev.Data);
                process.BeginErrorReadLine();

                process.WaitForExit();
                process.Close();
            }

        }

        private void btnCreateEsUsers_Click(object sender, EventArgs e)
        {
            var processInfo = new ProcessStartInfo($@"{installPath}/RelativityDataGrid/elasticsearch-main/bin/shield/esusers.bat", $@"useradd {node.EsUserName} -p {node.EsPassWord} -r admin");

            processInfo.CreateNoWindow = true;
            processInfo.UseShellExecute = false;
            processInfo.RedirectStandardError = true;
            processInfo.RedirectStandardOutput = true;

            var process = Process.Start(processInfo);

            process.OutputDataReceived += (object psender, DataReceivedEventArgs ev) =>
                Console.WriteLine("output>>" + ev.Data);
            process.BeginOutputReadLine();

            process.ErrorDataReceived += (object psender, DataReceivedEventArgs ev) =>
                Console.WriteLine("error>>" + ev.Data);
            process.BeginErrorReadLine();

            process.WaitForExit();
            process.Close();

            MessageBox.Show("Elastic REST user created.");
        }

        private void Form2_FormClosed(object sender, FormClosedEventArgs e)
        {
            var form1 = (Form1)Tag;
            Hide();
            form1.Show();
        }

        private void listBoxJava_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            int index = listBoxJava.IndexFromPoint(e.Location);
            if(index != ListBox.NoMatches)
            {
                textBoxJavaHome.Text = listBoxJava.SelectedItem.ToString();
            }
        }

        bool DoesServiceExist(string serviceName)
        {
            ServiceController[] services = ServiceController.GetServices();
            var service = services.FirstOrDefault(s => s.ServiceName == serviceName);
            return service != null;
        }

        private void btnStartES_Click(object sender, EventArgs e)
        {
            if (DoesServiceExist("elasticsearch-service-x64"))
            {
                ServiceController elastic = new ServiceController("elasticsearch-service-x64");
                if (elastic.Status == ServiceControllerStatus.Stopped)
                {
                    elastic.Start();
                    MessageBox.Show("Started the Elastic Windows service.");
                } else
                {
                    MessageBox.Show("The Elastic Windows service is not stopped.");
                }
            }
            else
            {
                MessageBox.Show("The elastic service was not found.");
            }
        }

        private void btnStopES_Click(object sender, EventArgs e)
        {
            if (DoesServiceExist("elasticsearch-service-x64"))
            {
                ServiceController elastic = new ServiceController("elasticsearch-service-x64");
                if (elastic.Status == ServiceControllerStatus.Running)
                {
                    elastic.Stop();
                    MessageBox.Show("Stopped the Elastic Windows service.");
                }
                else
                {
                    MessageBox.Show("The Elastic Windows service is not running.");
                }
            }
            else
            {
                MessageBox.Show("The elastic service was not found.");
            }
        }

        private void btnGetWebCert_Click(object sender, EventArgs e)
        {
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create($@"https://{node.AuthenticationWebServer}/Relativity/Identity/.well-known/jwks");
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                response.Close();
                X509Certificate cert = request.ServicePoint.Certificate;

                MessageBox.Show("Certificate Captured.");
                void ExportToPEM(X509Certificate certToExport)
                {
                    StringBuilder builder = new StringBuilder();

                    builder.AppendLine("-----BEGIN CERTIFICATE-----");
                    builder.AppendLine(Convert.ToBase64String(cert.Export(X509ContentType.Cert), Base64FormattingOptions.InsertLineBreaks));
                    builder.AppendLine("-----END CERTIFICATE-----");

                    string pem = builder.ToString();
                    File.WriteAllText("ShieldCert.pem", pem);                 
                }
                ExportToPEM(cert);

            }
            catch (System.UriFormatException)
            {
                MessageBox.Show("Specify a Authentication Web server in the previous form.");
            }
            catch (System.Net.WebException eWeb) when (eWeb.Message == "The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel.")
            {
                MessageBox.Show("The Authentication Web server certificate is not trusted.");
            }              
        }
    }
}
