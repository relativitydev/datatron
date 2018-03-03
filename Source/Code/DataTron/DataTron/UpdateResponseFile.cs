using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace DataTron
{
    class UpdateResponseFile
    {
        public static string[] UpdateResponseFileText(Node node, string StringToParse, string NewValue, string[] linesArray)
        {
            string[] ParseResponse()
            {
                string StringEntryFull = Array.Find(linesArray, element => element.StartsWith(StringToParse));

                for(int i= 0; i < linesArray.Length; i++)
                {
                    if (linesArray[i].StartsWith(StringToParse))
                    {
                        linesArray[i] = StringToParse + NewValue;
                        Console.WriteLine(linesArray[i]);
                    }                 
                }
                return linesArray;
            }
            string[] newLinesArray = ParseResponse();
            return newLinesArray;
        }
    }
}
