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
    public class SupplierController : Controller
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(SupplierController));
        private IConfiguration Configuration { get; set; }
        private ISupplier Supplier { get; set; }

        public SupplierController(IConfiguration configuration, ISupplier supplier)
        {
            Configuration = configuration;
            Supplier = supplier;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetSuppliers()
        {
            List<SupplierViewModel> supplierViewModels;

            try
            {
                supplierViewModels = (List<SupplierViewModel>)await Supplier.GetSuppliersAsync(Configuration["ConnectionStrings:Default"]);

                return new JsonResult(supplierViewModels)
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to retrieve suppliers.", ex);

                return new JsonResult("Failed to retrieve suppliers")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public IActionResult CreateSupplier()
        {
            ViewData["supplierFunction"] = "Create New Supplier(s)";
            ViewData["url"] = "/Supplier/CreateSupplier";

            return PartialView("~/Views/Supplier/_CreateEditSupplier.cshtml", new SupplierViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateSupplier([FromBody] SupplierViewModel supplierViewModel)
        {
            try
            {
                await Supplier.CreateSupplierAsync(Configuration["ConnectionStrings:Default"], supplierViewModel);
            }
            catch(SqlException sqlEx)
            {
                if(sqlEx.Number == 2627)
                {
                    log.Error("Supplier Code already exist.", sqlEx);

                    return new JsonResult("Supplier Code already exist.")
                    {
                        StatusCode = StatusCodes.Status400BadRequest
                    };
                }

                log.Error("Failed to create supplier.", sqlEx);

                return new JsonResult("Failed to create supplier")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to create supplier.", ex);

                return new JsonResult("Failed to create supplier")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null){ StatusCode = StatusCodes.Status200OK};
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteSupplier([FromBody]long supplierId)
        {
            try
            {
                await Supplier.DeleteSupplierAsync(Configuration["ConnectionStrings:Default"], supplierId);
            }
            catch (Exception ex)
            {
                log.Error("Failed to delete supplier.", ex);

                return new JsonResult("Failed to delete supplier")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditSupplier(long supplierId)
        {
            SupplierViewModel supplier;

            try
            {
                supplier = await Supplier.GetSupplierByIdAsync(Configuration["ConnectionStrings:Default"], supplierId);
            }
            catch (Exception ex)
            {
                log.Error("Failed to retrieve supplier details.", ex);

                return new JsonResult("Failed to retrieve supplier details.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            ViewData["supplierFunction"] = "Edit Supplier";
            ViewData["url"] = "/Supplier/EditSupplier";

            return PartialView("~/Views/Supplier/_CreateEditSupplier.cshtml", supplier);
        }

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public async Task<IActionResult> EditSuppplier([FromBody] SupplierViewModel supplierViewModel)
        {
            try
            {
                await Supplier.EditSupplierAsync(Configuration["ConnectionStrings:Default"], supplierViewModel);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
                {
                    log.Error("Supplier Code already exist.", sqlEx);

                    return new JsonResult("Supplier Code already exist.")
                    {
                        StatusCode = StatusCodes.Status400BadRequest
                    };
                }

                log.Error("Failed to create supplier.", sqlEx);

                return new JsonResult("Failed to create supplier")
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to update supplier.", ex);

                return new JsonResult("Failed to update supplier.")
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }
    }
}
