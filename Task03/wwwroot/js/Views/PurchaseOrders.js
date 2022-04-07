"use strict";

var PurchaseOrderTable, PO_ItemTable;


$(document).ready(function () {

    iniSelSuppliers();

    iniTblPurchaseOrders(0);
});

var iniTblPurchaseOrders = function (supplierId) {
    if (typeof PurchaseOrderTable !== 'undefined') {
        PurchaseOrderTable.destroy();
        document.getElementById("tblPO").innerHTML = "";
    }

    PurchaseOrderTable = $('#tblPO').DataTable({
        "responsive": true,
        "processing": true,
        "ajax": {
            "url": `/PurchaseOrder/GetPurchaseOrdersBySupplierId?supplierId=${supplierId}`,
            "type": "GET",
            "dataType": "json",
            "headers": {
                "RequestVerificationToken": $("[name=__RequestVerificationToken]").val().toString()
            },
            "dataSrc": (json) => {
                console.log(json);
                return json;
            },
        },
        "columns": [
            { "data": "purchaseOrderNr", "name": "PurchaseOrderNr", "title": "PurchaseOrderNr" },
            { "data": "purchaseOrderDateTime", "name": "PurchaseOrderDateTime", "title": "PurchaseOrderDateTime" },
            { "data": "totalTax", "name": "POVat", "title": "VAT" },
            { "data": "grandTotal", "name": "POTotal", "title": "Total" },
            {
                "data": null, "name": "action", "title": "", "width": '20%', "render": (data, type, row) => {
                    return `
                                      <button type="button" data-id="${data.purchaseOrderID}" data-supplierid="${data.supplierID}" class="btn btn-sm btn-primary btnProducts">Products</button>
                                      <button type="button" data-id="${data.purchaseOrderID}" class="btn btn-sm btn-danger btnRemovePO">Remove</button>
                            `;
                }
            }

            //{ "data": "SupplierCode", "name": "SupplierCode", "title": "SupplierCode" },
            //{ "data": "SupplierName", "name": "SupplierName", "title": "SupplierName" }
        ]
    });

    $("#tblPO tbody").on("click", ".btnProducts", function (event) {
        //loadEditProduct($(this).data("id"));
        loadCreateNewPO_items($(this).data("id"), $(this).data("supplierid"));
    });

    $("#tblPO tbody").on("click", ".btnRemovePO", function (event) {

        $("#confirmationModal").modal("show");
        $("#btnConfirmationProceed").html(`<button id="btnDeletePurchaseOrder" data-id="${$(this).data("id")}" type="button" class="btn btn-primary">Proceed</button>`);

        $("#btnDeletePurchaseOrder").on("click", function () {
            ajaxHelper("/PurchaseOrder/DeletePurchaseOrder", "POST", null, $(this).data("id"), function () {
                showMsg("Successfull", MsgType.success);
                $("#confirmationModal").modal("hide");
                PurchaseOrderTable.ajax.reload();
            });
        });
    });
};

var iniTblPurchaseOrdersItems = function (purchaseOrderId) {
    if (typeof PO_ItemTable !== 'undefined') {
        PO_ItemTable.destroy();
        document.getElementById("tblPO_Items").innerHTML = "";
    }

    PO_ItemTable = $('#tblPO_Items').DataTable({
        "responsive": true,
        "processing": true,
        "ajax": {
            "url": `/PurchaseOrder/GetPurchaseOrderProductByPoId?purchaseOrderId=${purchaseOrderId}`,
            "type": "GET",
            "dataType": "json",
            "headers": {
                "RequestVerificationToken": $("[name=__RequestVerificationToken]").val().toString()
            },
            "dataSrc": (json) => {
                console.log(json);
                return json;
            },
        },
        "columns": [
            //{ "data": "productCode", "name": "ProductCode", "title": "ProductCode" },
            { "data": "productName", "name": "ProductName", "title": "ProductName" },
            { "data": "quantity", "name": "POQuantity", "title": "Quantity" },
            { "data": "unitPrice", "name": "UnitPrice", "title": "UnitPrice" },
            { "data": "tax", "name": "Tax", "title": "Tax" },
            { "data": "subtotal", "name": "Subtotal", "title": "Subtotal" },
            {
                "data": null, "name": "action", "title": "", "width": '20%', "render": (data, type, row) => {
                    return `
                           <button type="button" data-id="${data.id}" class="btn btn-sm btn-danger btnRemovePoProduct">Delete</button>
                            `;
                }
            }
        ]
    });

    $("#tblPO_Items tbody").on("click", ".btnRemovePoProduct", function (event) {
        if (confirm("Do you want to delete product from Purchase Order?")) {

            ajaxHelper("/PurchaseOrder/DeletePurchaseOrderProductById", "POST", null, $(this).data("id"), function () {
                showMsg("Successfull", MsgType.success);
                PO_ItemTable.ajax.reload();
            });
        }
    });
};

(function () {

    $('#selPOSuppliers').on('select2:select', function (e) {
        if ($("#selPOSuppliers").val() === "") {
            showMsg("Please select a Supplier", MsgType.warning)
            return;
        }

        iniSelSupplierProducts($("#selPOSuppliers").val());
    });

    //$("#btnCreateNewPO").on("click", function () {
    //    if ($("#selPOSuppliers").val() === "") {
    //        showMsg("Please select a supplier", MsgType.warning)
    //        return;
    //    }

    //    if ($("#selPOProducts").val() === "") {
    //        showMsg("Please select a Product", MsgType.warning)
    //        return;
    //    }

    //    if ($("#inputPOQNr").val() === "") {
    //        showMsg("Please Enter Order No.", MsgType.warning)
    //        return;
    //    }
    //    if ($("#inputPOQty").val() === "") {
    //        showMsg("Please Enter Product Quantity.", MsgType.warning)
    //        return;
    //    }


    //    loadCreateNewPO();
    //});

    $("#btnLoadPO").on("click", function () {
        if ($("#selPOSuppliers").val() === "") {
            showMsg("Please select a supplier", MsgType.warning);
            return false;
        }

        iniTblPurchaseOrders($("#selPOSuppliers").val());
    });

    $("#btnCreateNewPO").on("click", function () {
        if ($("#selPOSuppliers").val() === "") {
            showMsg("Please select a supplier", MsgType.warning);
            return false;
        }

        if ($("#inputPOQNr").val() === "") {
            showMsg("Enter purchase Order No.", MsgType.warning);
            return false;
        }
        submitPoCreateData();
        return false;
    });

})();

var iniSelSuppliers = function () {
    ajaxHelper("/Supplier/GetSuppliers", "GET", null, null, function (data) {
        var selectData = [];
        $.each(data, function (index, value) {
            selectData.push({ id: value.supplierID, text: `(${value.supplierCode}) ${value.supplierName}` })
        });

        $("#selPOSuppliers").select2({
            data: selectData,
            placeholder: "Suppliers"
        });
    });
};

var iniSelSupplierProducts = function (supplierId) {
    if (typeof ProductTable !== 'undefined') { }

    ajaxHelper(`/Product/GetProductsBySupplierId?supplierId=${supplierId}`, "GET", null, null, function (data) {
        var selectData = [];
        $.each(data, function (index, value) {
            selectData.push({ id: value.productID, text: `(${value.productCode}) ${value.productName}` })
        });

        $("#selPOProducts").select2({
            data: selectData,
            placeholder: "Products"
        });
    });
};


var loadEditPO_items = function (id) {
    LoadPartial("#createEditView", "PurchageOrder", "EditPurchageOrder", `?purchageOrderId=${id}`, function () {
        $("#btnAddAnother").hide();
        showCreateEditProduct();
    });
};

var loadCreateNewPO_items = function (po_id, supplierId) {
    LoadPartial("#createPoItemsView", "PurchaseOrder", "CreatePurchaseOrderProduct", "", function () {
        $("#btnAddAnother").show();
        showCreateEditPO_items(po_id, supplierId);
    });
};

var showCreateEditPO_items = function (po_id, supplierId) {

    $("#btnCancel").on("click", function () {
        $("#divCreateEditPoProduct").modal("hide");
    });

    $("#btnDone").on("click", function (e) {
        submitProductData(true);
    });

    $("#btnAddAnother").on("click", function () {
        submitProductData(false);
    });

    $("#divCreateEditPoProduct").modal("show");

    $('#hfPurchaseOrderId').val(po_id);
    $('#hfSupplierId').val(supplierId);

    $('#divCreateEditPoProduct').on('shown.bs.modal', function (event) {
        iniSelSupplierProducts(supplierId);
        $('#selPOProducts').trigger('focus');
        iniTblPurchaseOrdersItems(po_id);
    })
};

var submitPoCreateData = function () {
    var form = document.forms["frmPurchaseOrder"];

    var purchageOrderViewModel = {};
    purchageOrderViewModel.SupplierID = form.elements["selPOSuppliers"].value;
    purchageOrderViewModel.PurchaseOrderNr = form.elements["inputPOQNr"].value;

    ajaxHelper("/PurchaseOrder/CreatePurchaseOrder", "POST", null, purchageOrderViewModel, function () {
        //document.forms["frmPurchaseOrder"].reset();
        showMsg("Successfull", MsgType.success);
        //if (hideDialog)
        //    $("#divCreateEditSupplier").modal("hide");
        PurchaseOrderTable.ajax.reload();
    });
}

var submitProductData = function (hideDialog) {
    var form = document.forms["frmPurchaseOrderItem"];

    var productViewModel = {};
    productViewModel.Tax = form.elements["inputTax"].value;

    productViewModel.ID = form.elements["hfPO_ProductId"].value;

    productViewModel.PurchaseOrderID = form.elements["hfPurchaseOrderId"].value;

    productViewModel.Quantity = form.elements["inputPOQuantity"].value;

    productViewModel.ProductID = Number.parseInt($("#selPOProducts").val());

    ajaxHelper($("#hfUrl").val(), "POST", null, productViewModel, function () {
        document.forms["frmPurchaseOrderItem"].reset();
        showMsg("Successfull", MsgType.success);
        //if (hideDialog)
        //    $("#divCreateEditProduct").modal("hide");
        PO_ItemTable.ajax.reload();
    });
};