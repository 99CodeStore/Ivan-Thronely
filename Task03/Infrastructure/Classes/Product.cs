using Dapper;
using Task03.Infrastructure.Interfaces;
using Task03.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Infrastructure.Classes
{
    public class Product : IProduct
    {
        public async Task CreateProductAsync(string dbConnectionStr, ProductViewModel productViewModel)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", productViewModel.SupplierID);
                dp.Add("@ProductCode", productViewModel.ProductCode);
                dp.Add("@ProductName", productViewModel.ProductName);
                dp.Add("@ProductPrice", productViewModel.ProductPrice);

                await dapCon.ExecuteAsync("usp_CreateProduct", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        public async Task DeleteProductByIdAsync(string dbConnectionStr, long productId)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@ProductID", productId);

                await dapCon.ExecuteAsync("usp_DeleteProductById", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        public async Task EditProductByIdAsync(string dbConnectionStr, ProductViewModel productViewModel)
        {
            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@ProductID", productViewModel.ProductID);
                dp.Add("@SupplierID", productViewModel.SupplierID);
                dp.Add("@ProductCode", productViewModel.ProductCode);
                dp.Add("@ProductName", productViewModel.ProductName);
                dp.Add("@ProductPrice", productViewModel.ProductPrice);

                await dapCon.ExecuteAsync("usp_EditProductById", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }
        }

        public async Task<ProductViewModel> GetProductByIdAsync(string dbCOnnectionStr, long productId)
        {
            ProductViewModel returnData = new ProductViewModel();

            using (var dapCon = new SqlConnection(dbCOnnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@ProductId", productId);

                returnData = await dapCon.QueryFirstOrDefaultAsync<ProductViewModel>("usp_GetProductById", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }

        public async Task<IEnumerable<ProductViewModel>> GetProductsBySupplierIdAsync(string dbConnectionStr, long supplierId)
        {
            IEnumerable<ProductViewModel> returnData;

            using (var dapCon = new SqlConnection(dbConnectionStr))
            {
                DynamicParameters dp = new DynamicParameters();
                dp.Add("@SupplierID", supplierId);

                returnData = await dapCon.QueryAsync<ProductViewModel>("usp_GetProductsBySupplierId", dp, commandType: System.Data.CommandType.StoredProcedure, commandTimeout: int.MaxValue);
            }

            return returnData;
        }
    }
}
