using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Models
{
    public class PurchaseOrderViewModel
    {
        public int PurchaseOrderID { get; set; }
        public string PurchaseOrderNr { get; set; }
        public DateTime? PurchaseOrderDateTime { get; set; }
        public int SupplierID { get; set; }
        public float TotalTax { get; set; }
        public double GrandTotal { get; set; }
    }
}
