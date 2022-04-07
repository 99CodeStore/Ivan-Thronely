using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Models
{
    public class PurchaseOrderProductViewModel
    {
        public int ID { get; set; }
        public int PurchaseOrderID { get; set; }
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public float UnitPrice { get; set; }
        public float Tax { get; set; }
        public float Subtotal { get; set; }
        public string ProductName { get; set; }
        public string ProductCode { get; set; }
    }
}
