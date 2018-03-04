using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace DataTron
{
    class RunLog
    {
        public void Frogger(string log)
        {
            File.AppendAllText("log.txt",log);
        }
    }
}

