using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DataTron
{
    public static class CertGrab
    {
        public static void Grab(Node node)
        {
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create($@"https://{node.AuthenticationWebServer}/Relativity/Identity/.well-known/jwks");
                request.ServerCertificateValidationCallback = ServerCertificateValidationCallback;

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                response.Close();
 
                MessageBox.Show("Certificate Captured.");

                bool ServerCertificateValidationCallback(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
                {

                    //foreach (var cer in chain.ChainElements)
                    //{
                    //    ExportToPEM(cer.Certificate);
                    //}

                    Int32 i = 0;
                    foreach (var cer in chain.ChainElements)
                    {
                        ExportToPEM(cer.Certificate, i);
                        i++;
                    }

                    void ExportToPEM(X509Certificate2 certToExport, Int32 j)
                    {
                        StringBuilder builder = new StringBuilder();

                        builder.AppendLine("-----BEGIN CERTIFICATE-----");
                        builder.AppendLine(Convert.ToBase64String(certToExport.Export(X509ContentType.Cert), Base64FormattingOptions.InsertLineBreaks));
                        builder.AppendLine("-----END CERTIFICATE-----");

                        string pem = builder.ToString();
                        File.WriteAllText($@"ShieldCert_{j}.pem", pem);
                    }
                    return true;
                }

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
