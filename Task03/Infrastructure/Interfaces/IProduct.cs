using Task03.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Infrastructure.Interfaces
{
    public interface IProduct
    {
        Task<IEnumerable<ProductViewModel>> GetProductsBySupplierIdAsync(string dbConnectionStr, long supplierId);
        Task CreateProductAsync(string dbConnectionStr, ProductViewModel productViewModel);
        Task DeleteProductByIdAsync(string dbConnectionStr, long productId);
        Task EditProductByIdAsync(string dbConnectionStr, ProductViewModel productViewModel);
        Task<ProductViewModel> GetProductByIdAsync(string dbCOnnectionStr, long productId);
    }
}
