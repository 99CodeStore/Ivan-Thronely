using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task02
{
    class Program
    {
        static List<Employee> employees = new List<Employee>();
        static void Main(string[] args)
        {

            char operationcode;
            do
            {

                Console.WriteLine($"Operation Inputs:- 1->To Add Employee, 2-> To Find Reporting subordinates and 3--> To Exit");

                operationcode = Console.ReadKey().KeyChar;
                Console.WriteLine();
                switch (operationcode)
                {
                    case '1':

                        Console.WriteLine("Enter Employee Name followed by Manager Name by (,) seperating to Add : ");
                        string newEmpdata = Console.ReadLine();
                        if (!string.IsNullOrEmpty(newEmpdata))
                        {
                            string[] data = newEmpdata.Split(',');
                            if (data.Length == 2)
                            {
                                AddNewEmployee(data[0], data[1]);
                            }
                            else
                            {
                                AddNewEmployee(data[0], "");
                            }
                        }
                        else
                        {
                            Console.WriteLine("Invalid data try again.");
                        }

                        break;
                    case '2':
                        Console.WriteLine("Enter Employee Name to find his/her all all sub-ordinates :");
                        string emp = Console.ReadLine();

                        FindAllsubordinates(emp);


                        break;
                    default:
                        Console.WriteLine("Invalid Operation Code");
                        break;
                }
            }
            while (operationcode != '3');


        }

        static void AddNewEmployee(string empName, string managerName)
        {
            // Adding at top level 
            if (string.IsNullOrEmpty(managerName))
            {
                if (employees.Count > 0)
                {
                    Console.WriteLine();
                    Console.WriteLine("Data Error :- Only one Employee can be at top level. Employee not added on organization hierarchy.");
                }
                else
                {
                    employees.Add(new Employee(empName, ""));
                    Console.WriteLine();
                    Console.WriteLine($"Success :- {empName} added as a top level employee.");
                }
            }
            else
            {
                var matches = employees.Where(p => p.Name == managerName);
                if (matches.Count() > 0)
                {
                    employees.Add(new Employee(empName, managerName));
                    Console.WriteLine();
                    Console.WriteLine($"Success :- {empName} added as a subordinate of {managerName}.");
                }
                else
                {
                    Console.WriteLine();
                    Console.WriteLine($"Data Error :- {managerName} not find in organization hierarchy. {empName} not added.");
                }
            }
            Console.WriteLine();
            Console.WriteLine($"Now total No of employee : {employees.Count()} on organization.");
        }


        static void FindAllsubordinates(string input)
        {
            foreach (var emp in employees)
            {
                if (emp.Name == input)
                {
                    Console.WriteLine(FindSubordinates_Helper(input));
                    return;
                }
            }
            Console.WriteLine($"Data Error :- {input} not found in the organization hierarchy.");
        }
        static string FindSubordinates_Helper(string input)
        {
            var matches = employees.Where(p => p.Manager == input);

            StringBuilder sbResult = new StringBuilder();

            foreach (var item in matches)
            {
                if (sbResult.Length == 0)
                {
                    sbResult.Append(item.Name);
                }
                else
                {
                    sbResult.Append(",").Append(item.Name);
                }

                string res = FindSubordinates_Helper(item.Name);
                if (!string.IsNullOrEmpty(res))
                {
                    sbResult.Append(",").Append(res);
                }
            }
            return sbResult.ToString();
        }

        class Employee
        {
            public string Name { get; set; }
            public string Manager { get; set; }

            public Employee(string name, string manager)
            {
                this.Name = name;
                this.Manager = manager;
            }
        }
    }
}
