using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task01
{
    class Program
    {
        
        /*
        Problem 1
        There is a list of items in a system that are identified by one or more words. A user wants to search through the items by entering parts of the words. 
        The items in the system are described by the following words:
        Users, User Groups, User Activity Log, Report Designer, Report Activity Log, Security, Security Log, Security Access, Security Management, Databases, Database Management, Database Control, Printers, Printer Control.
        Here are some examples of how the system should match the users search words to items.
        
        Search Words	Matched Items
        u	            Users, User Groups, User Activity Log
        u l	            User Activity Log
        u gr	        User Groups
        ivi	            User Activity Log, Report Activity Log
        man	            Security Management, Database Management
        */
        static void Main(string[] args)
        {
      
            string rawList = "Users,User Groups,User Activity Log,Report Designer,Report Activity Log,Security,Security Log,Security Access,Security Management,Databases,Database Management,Database Control,Printers,Printer Control";
            string[] list = rawList.Split(',');

            Console.Write("Enter search words[Multiple word should be space seperated] :");
            var searchWords = Console.ReadLine();
            if (string.IsNullOrEmpty(searchWords))
            {
                Console.Write("You didn`t enter any value to search.");
            }
            else
            {
                string searchResult = "";
                string[] searchwordsList = searchWords.Trim().Split(' ');
                for (int i = 0; i < list.Length; i++)
                {
                    bool match = true;
                    for (int j = 0; j < searchwordsList.Length; j++)
                    {
                        if (!list[i].ToLower().Contains(searchwordsList[j].ToLower()))
                        {
                            match = false;
                        }

                    }
                    if (match)
                    {
                        searchResult +=  $"{list[i]},";
                    }
                }

                Console.WriteLine($"Search Result :{searchResult}");
            }
            Console.ReadKey();
        }
    }
}
