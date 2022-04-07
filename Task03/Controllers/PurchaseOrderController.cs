using log4net;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Task03.Infrastructure.Interfaces;
using Task03.Models;

namespace Task03.Controllers
{
    public class PurchaseOrderController : Controller
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(PurchaseOrderController));
        private IConfiguration Configuration { get; set; }
        private IPurchaseOrder PurchaseOrder { get; set; }

        public PurchaseOrderController(IConfiguration configuration, IPurchaseOrder purchaseOrder)
        {
            Configuration = configuration;
            PurchaseOrder = purchaseOrder;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetPurchaseOrdersBySupplierId(long supplierId)
        {
            List<PurchaseOrderViewModel> productViewModels;

            try
            {
                productViewModels = (List<PurchaseOrderViewModel>) await PurchaseOrder.GetPurchaseOrderBySupplierIdAsync(Configuration["ConnectionStrings:Default"], supplierId);

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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreatePurchaseOrder([FromBody] PurchaseOrderViewModel purchaseOrderViewModel)
        {
            try
            {
                await PurchaseOrder.CreatePurchaseOrderAsync(Configuration["ConnectionStrings:Default"], purchaseOrderViewModel);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
                {
                    log.Error("Purchase Order Number Code already exist for this supplier.", sqlEx);

                    return new JsonResult("Purchase Order Number already exist.")
                    {
                        StatusCode = StatusCodes.Status400BadRequest
                    };
                }

                log.Error("Failed to Purchase Order.", sqlEx);

                return new JsonResult("Failed to create Purchase Order.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to create Purchase Order.", ex);

                return new JsonResult("Failed to create Purchase Order.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeletePurchaseOrder([FromBody]long purchaseOrderId)
        {
            try
            {
                await PurchaseOrder.DeletePurchaseOrderByIdAsync(Configuration["ConnectionStrings:Default"], purchaseOrderId);
            }
            catch (Exception ex)
            {
                log.Error("Failed to Delete Purchase Order.", ex);

                return new JsonResult("Failed to Delete Purchase Order")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

        #region PO Products Methods

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetPurchaseOrderProductByPoId(long purchaseOrderId)
        {
            List<PurchaseOrderProductViewModel> productViewModels;

            try
            {
                productViewModels = (List<PurchaseOrderProductViewModel>)await PurchaseOrder.GetPurchaseOrderProductByPoIdAsync(Configuration["ConnectionStrings:Default"], purchaseOrderId);

                return new JsonResult(productViewModels)
                {
                    StatusCode = StatusCodes.Status200OK
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to retrieve PO products.", ex);

                return new JsonResult("Failed to retrieve PO products.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public IActionResult CreatePurchaseOrderProduct()
        {
            ViewData["po_productFunction"] = "Create Purchase Order New Product(s)";
            ViewData["url"] = "/PurchaseOrder/CreatePurchaseOrderProduct";

            return PartialView("~/Views/PurchaseOrder/_CreateEditPurchaseOrderProduct.cshtml", new PurchaseOrderProductViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreatePurchaseOrderProduct([FromBody] PurchaseOrderProductViewModel PurchaseOrderProductViewModel)
        {
            try
            {
                await PurchaseOrder.CreatePurchaseOrderProductAsync(Configuration["ConnectionStrings:Default"], PurchaseOrderProductViewModel);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
                {
                    log.Error("Product already exist for this Purchase Order.", sqlEx);

                    return new JsonResult("Product already exist for this Purchase Order.")
                    {
                        StatusCode = StatusCodes.Status400BadRequest
                    };
                }

                log.Error("Failed to create Purchase Order Product.", sqlEx);

                return new JsonResult("Failed to create Purchase Order Product.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }
            catch (Exception ex)
            {
                log.Error("Failed to create Purchase Order Product.", ex);

                return new JsonResult("Failed to create Purchase Order Product.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeletePurchaseOrderProductById([FromBody]long Id)
        {
            try
            {
                await PurchaseOrder.DeletePurchaseOrderProductByIdAsync(Configuration["ConnectionStrings:Default"], Id);
            }
            catch (Exception ex)
            {
                log.Error("Failed to Delete Purchase Order Product.", ex);

                return new JsonResult("Failed to Delete Purchase Order Product.")
                {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new JsonResult(null) { StatusCode = StatusCodes.Status200OK };
        }


        #endregion

    }
}
