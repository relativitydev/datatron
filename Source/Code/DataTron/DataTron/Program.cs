using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DataTron
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// Developed by Ivan Koretsky for the Relativity Corporation.
        /// The RelativityDataGrid media is available to currently licensed clients of Relativity Corporation.
        /// Do more with less!
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
