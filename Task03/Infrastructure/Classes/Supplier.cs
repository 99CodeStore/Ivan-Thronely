using Dapper;
using Task03.Infrastructure.Interfaces;
using Task03.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Infrastructure.Classes
{
    public class Supplier : ISupplier
    {
        /// <summary>
        /// Create a new supplier entity
        /// </summary>
        /// <param name="dbConnectionStr">SQL Connection String</param>
        /// <param name="supplier">Supplier Model</param>
        /// <returns></returns>
        public async Task CreateSupplierAsync(string dbConnectionStr, SupplierViewModel supplier)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierCode", supplier.SupplierCode);
                dp.Add("@SupplierName", supplier.SupplierName);

                await dapCon.ExecuteAsync("usp_CreateSupplier", dp, commandType: CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        /// <summary>
        /// Delete a supplier
        /// </summary>
        /// <param name="dbConnectionStr">SQL Connection String</param>
        /// <param name="supplierId">Supplier ID to be deleted</param>
        /// <returns></returns>
        public async Task DeleteSupplierAsync(string dbConnectionStr, long supplierId)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", supplierId);

                await dapCon.ExecuteAsync("usp_DeleteSupplier", dp, commandType: CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        /// <summary>
        /// Edit a supplier
        /// </summary>
        /// <param name="dbConnectionStr">SQL Connection String</param>
        /// <param name="supplier">Supplier Model to be updated</param>
        /// <returns></returns>
        public async Task EditSupplierAsync(string dbConnectionStr, SupplierViewModel supplier)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", supplier.SupplierID);
                dp.Add("@SupplierCode", supplier.SupplierCode);
                dp.Add("@SupplierName", supplier.SupplierName);

                await dapCon.ExecuteAsync("usp_EditSupplier", dp, commandType: CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        /// <summary>
        /// Retrieve Supplier by ID
        /// </summary>
        /// <param name="dbCOnnectionStr">SQL Connection String</param>
        /// <param name="supplierId">Supplier ID that needs to be retrieved</param>
        /// <returns></returns>
        public async Task<SupplierViewModel> GetSupplierByIdAsync(string dbCOnnectionStr, long supplierId)
        {
            SupplierViewModel returnData = new SupplierViewModel();

            using (var dapCon = new SqlConnection(dbCOnnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", supplierId);

                returnData = await dapCon.QueryFirstOrDefaultAsync<SupplierViewModel>("usp_GetSupplierById", dp, commandType: CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }

        /// <summary>
        /// Retrieve full supplier list
        /// </summary>
        /// <param name="dbConnectionStr">SQL Connection String</param>
        /// <returns></returns>
        public async Task<IEnumerable<SupplierViewModel>> GetSuppliersAsync(string dbConnectionStr)
        {
            IEnumerable<SupplierViewModel> returnData;

            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                returnData = await dapCon.QueryAsync<SupplierViewModel>("usp_GetSuppliers", null, commandType: CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }
    }
}
