using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace DataTron
{
    class RESTRequest
    {
        public static string getRequest(Uri URI, string username, string password)
        {
            HttpClient client = new HttpClient();
            client.BaseAddress = URI;
            byte[] cred = UTF8Encoding.UTF8.GetBytes($@"{username}:{password}");
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Basic", Convert.ToBase64String(cred));
            client.DefaultRequestHeaders.Accept.Add(new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue("application/json"));

            System.Net.Http.HttpContent content = new StringContent("", UTF8Encoding.UTF8, "application/json");
            HttpResponseMessage messge = client.GetAsync(URI).Result;
            string description = string.Empty;
            if (messge.IsSuccessStatusCode)
            {
                string result = messge.Content.ReadAsStringAsync().Result;
                description = result;
            }
            return description;
        }

        public static string putRequest(Uri URI, string username, string password, string body)
        {
            HttpClient client = new HttpClient();
            client.BaseAddress = URI;
            byte[] cred = UTF8Encoding.UTF8.GetBytes($@"{username}:{password}");
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Basic", Convert.ToBase64String(cred));
            client.DefaultRequestHeaders.Accept.Add(new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue("application/json"));

            System.Net.Http.HttpContent content = new StringContent(body, UTF8Encoding.UTF8, "application/json");
            HttpResponseMessage messge = client.PutAsync(URI, content).Result;
            string description = string.Empty;
            if (messge.IsSuccessStatusCode)
            {
                string result = messge.Content.ReadAsStringAsync().Result;
                description = result;
            }
            return description;
        }

    }
}
