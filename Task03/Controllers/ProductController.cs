using log4net;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Task03.Infrastructure.Interfaces;
using Task03.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace Task03.Controllers
{
    public class ProductController : Controller
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(ProductController));
        private IConfiguration Configuration { get; set; }
        private IProduct Product { get; set; }

        public ProductController(IConfiguration configuration, IProduct product)
        {
            Configuration = configuration;
            Product = product;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetProductsBySupplierId(long supplierId)
        {
            List<ProductViewModel> productViewModels;

            try
            {
                productViewModels = (List<ProductViewModel>)await Product.GetProductsBySupplierIdAsync(Configuration["ConnectionStrings:Default"], supplierId);

                return new JsonResult(productViewModels)
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to retrieve products.", ex);

                return new JsonResult("Failed to retrieve products.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public IActionResult CreateProduct()
        {
            ViewData["productFunction"] = "Create New Product(s)";
            ViewData["url"] = "/Product/CreateProduct";

            return PartialView("~/Views/Product/_CreateEditProduct.cshtml", new ProductViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateProduct([FromBody] ProductViewModel productViewModel)
        {
            try
            {
                await Product.CreateProductAsync(Configuration["ConnectionStrings:Default"], productViewModel);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
                {
                    log.Error("Product Code already exist for this supplier.", sqlEx);

                    return new JsonResult("Product Code already exist for this supplier.")
                    {
                        StatusCode = StatusCodes.Status400BadRequest
                    };
                }

                log.Error("Failed to create product.", sqlEx);

                return new JsonResult("Failed to create product.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to create product.", ex);

                return new JsonResult("Failed to create product.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditProduct(long productId)
        {
            ProductViewModel product;

            try
            {
                product = await Product.GetProductByIdAsync(Configuration["ConnectionStrings:Default"], productId);
            }
            catch (Exception ex)
            {
                log.Error("Failed to retrieve product details.", ex);

                return new JsonResult("Failed to retrieve product details.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            ViewData["productFunction"] = "Edit Product";
            ViewData["url"] = "/Product/EditProduct";

            return PartialView("~/Views/Product/_CreateEditProduct.cshtml", product);
        }

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public async Task<IActionResult> EditProduct([FromBody] ProductViewModel productViewModel)
        {
            try
            {
                await Product.EditProductByIdAsync(Configuration["ConnectionStrings:Default"], productViewModel);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
                {
                    log.Error("Product Code already exist.", sqlEx);

                    return new JsonResult("Product Code already exist.")
                    {
                        StatusCode = StatusCodes.Status400BadRequest
                    };
                }

                log.Error("Failed to create product.", sqlEx);

                return new JsonResult("Failed to create product")
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to update product.", ex);

                return new JsonResult("Failed to update product.")
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteProduct([FromBody]long productId)
        {
            try
            {
                await Product.DeleteProductByIdAsync(Configuration["ConnectionStrings:Default"], productId);
            }
            catch (Exception ex)
            {
                log.Error("Failed to delete product.", ex);

                return new JsonResult("Failed to delete product")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

    }
}
