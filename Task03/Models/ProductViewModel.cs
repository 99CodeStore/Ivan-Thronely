using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Models
{
    public class ProductViewModel
    {
        public long ProductID { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public decimal ProductPrice { get; set; }
        public long SupplierID { get; set; }
    }
}
