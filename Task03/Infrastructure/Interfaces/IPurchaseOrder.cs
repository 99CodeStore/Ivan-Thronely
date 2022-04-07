using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Task03.Models;

namespace Task03.Infrastructure.Interfaces
{
    public interface IPurchaseOrder
    {
        Task<IEnumerable<PurchaseOrderViewModel>> GetPurchaseOrderBySupplierIdAsync(string dbConnectionStr, long supplierId);
        Task CreatePurchaseOrderAsync(string dbConnectionStr, PurchaseOrderViewModel productOrderViewModel);
        Task DeletePurchaseOrderByIdAsync(string dbConnectionStr, long productId);
        Task<PurchaseOrderViewModel> GetPurchaseOrderByIdAsync(string dbConnectionStr, long purchaseOrderId);

        //Purchase Order Products Methods

        Task<IEnumerable<PurchaseOrderProductViewModel>> GetPurchaseOrderProductByPoIdAsync(string dbConnectionStr, long PurchaseOrderId);
        Task CreatePurchaseOrderProductAsync(string dbConnectionStr, PurchaseOrderProductViewModel productOrderProductViewModel);
        Task DeletePurchaseOrderProductByIdAsync(string dbConnectionStr, long productId);

    }
}
