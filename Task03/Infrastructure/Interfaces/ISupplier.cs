using Task03.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Infrastructure.Interfaces
{
    public interface ISupplier
    {
        Task<IEnumerable<SupplierViewModel>> GetSuppliersAsync(string dbConnectionStr);
        Task CreateSupplierAsync(string dbConnectionStr, SupplierViewModel supplier);
        Task DeleteSupplierAsync(string dbConnectionStr, long supplierId);
        Task EditSupplierAsync(string dbConnectionStr, SupplierViewModel supplier);
        Task<SupplierViewModel> GetSupplierByIdAsync(string dbCOnnectionStr, long supplierId);
    }
}
