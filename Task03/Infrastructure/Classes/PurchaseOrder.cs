using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Task03.Infrastructure.Interfaces;
using Task03.Models;

namespace Task03.Infrastructure.Classes
{
    public class PurchaseOrder : IPurchaseOrder
    {
        public async Task CreatePurchaseOrderAsync(string dbConnectionStr, PurchaseOrderViewModel productOrderViewModel)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", productOrderViewModel.SupplierID);
                dp.Add("@PurchaseOrderNr", productOrderViewModel.PurchaseOrderNr);
                await dapCon.ExecuteAsync("usp_CreatePurchaseOrder", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        public async Task DeletePurchaseOrderByIdAsync(string dbConnectionStr, long PurchaseOrderId)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@PurchaseOrderID", PurchaseOrderId);

                await dapCon.ExecuteAsync("usp_DeletePurchaseOrderById", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        public async Task<PurchaseOrderViewModel> GetPurchaseOrderByIdAsync(string dbConnectionStr, long PurchaseOrderId)
        {

            PurchaseOrderViewModel returnData = new PurchaseOrderViewModel();

            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@PurchaseOrderID", PurchaseOrderId);

                returnData = await dapCon.QueryFirstOrDefaultAsync<PurchaseOrderViewModel>("[dbo].[usp_GetPurchaseOrderById]", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }

        public async Task<IEnumerable<PurchaseOrderViewModel>> GetPurchaseOrderBySupplierIdAsync(string dbConnectionStr, long supplierId)
        {
            IEnumerable<PurchaseOrderViewModel> returnData;

            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", supplierId);

                returnData = await dapCon.QueryAsync<PurchaseOrderViewModel>("usp_GetPurchaseOrdersBySupplierId", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }

        // Purchase Order`s Product Methods
        public async Task<IEnumerable<PurchaseOrderProductViewModel>> GetPurchaseOrderProductByPoIdAsync(string dbConnectionStr, long purchaseOrderId)
        {
            IEnumerable<PurchaseOrderProductViewModel> returnData;

            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@purchaseOrderId", purchaseOrderId);

                returnData = await dapCon.QueryAsync<PurchaseOrderProductViewModel>("usp_GetPO_ProductsByPoId", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }
        public async Task CreatePurchaseOrderProductAsync(string dbConnectionStr, PurchaseOrderProductViewModel PO_ProductViewModel)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@PurchaseOrderID", PO_ProductViewModel.PurchaseOrderID);
                dp.Add("@ProductID", PO_ProductViewModel.ProductID);
                dp.Add("@POQuantity", PO_ProductViewModel.Quantity);
                dp.Add("@Tax", PO_ProductViewModel.Tax);

                await dapCon.ExecuteAsync("usp_CreatePurchaseOrderProduct", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }
        public async Task DeletePurchaseOrderProductByIdAsync(string dbConnectionStr, long Id)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@Id", Id);

                await dapCon.ExecuteAsync("usp_DeletePoProductById", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }
    }
}
