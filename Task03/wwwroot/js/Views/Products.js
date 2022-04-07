"use strict";

var ProductTable;

$(document).ready(function () {
    iniSelSuppliers();
    iniTblProducts(0);  
});

(function () {
    $("#btnCreateNewProduct").on("click", function () {
        if ($("#selSuppliers").val() === "") {
            showMsg("Please select a supplier", MsgType.warning)
            return;
        }

        loadCreateNewProduct();
    });

    $("#btnLoadSupplier").on("click", function () {
        if ($("#selSuppliers").val() === "") {
            showMsg("Please select a supplier", MsgType.warning)
            return;
        }

        iniTblProducts($("#selSuppliers").val());
    });
})();

var iniSelSuppliers = function () {
    ajaxHelper("/Supplier/GetSuppliers", "GET", null, null, function (data) {
        var selectData = [];
        $.each(data, function (index, value) {
            selectData.push({ id: value.supplierID, text: `(${value.supplierCode}) ${value.supplierName}`})
        });

        $("#selSuppliers").select2({
            data: selectData,
            placeholder: "Suppliers"
        });
    });
};

var iniTblProducts = function (supplierId) {
    if (typeof ProductTable !== 'undefined') {
        ProductTable.destroy();
        document.getElementById("tblProducts").innerHTML = "";
    }

    ProductTable = $('#tblProducts').DataTable({
        "responsive": true,
        "processing": true,
        "ajax": {
            "url": `/Product/GetProductsBySupplierId?supplierId=${supplierId}`,
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
            { "data": "productCode", "name": "productCode", "title": "Code" },
            { "data": "productName", "name": "productName", "title": "Name" },
            { "data": "productPrice", "name": "productPrice", "title": "Price"},
            {
                "data": null, "name": "action", "title": "", "width": '20%', "render": (data, type, row) => {
                    return `
                                      <button type="button" data-id="${data.productID}" class="btn btn-primary btnEditProduct">Edit</button>
                                      <button type="button" data-id="${data.productID}" class="btn btn-danger btnRemoveProduct">Remove</button>
                            `;
                }
            }
        ]
    });

    $("#tblProducts tbody").on("click", ".btnEditProduct", function (event) {
        loadEditProduct($(this).data("id"));
    });

    $("#tblProducts tbody").on("click", ".btnRemoveProduct", function (event) {
        $("#confirmationModal").modal("show");
        $("#btnConfirmationProceed").html(`<button id="btnDeleteSupplierProduct" data-id="${$(this).data("id")}" type="button" class="btn btn-primary">Proceed</button>`);

        $("#btnDeleteSupplierProduct").on("click", function () {
            ajaxHelper("/Product/DeleteProduct", "POST", null, $(this).data("id"), function () {
                showMsg("Successfull", MsgType.success);
                $("#confirmationModal").modal("hide");
                ProductTable.ajax.reload();
            });
        });
    });
};

var loadEditProduct = function (id) {
    LoadPartial("#createEditView", "Product", "EditProduct", `?productId=${id}`, function () {
        $("#btnAddAnother").hide();
        showCreateEditProduct();
    });
};

var loadCreateNewProduct = function () {
    LoadPartial("#createEditView", "Product", "CreateProduct", "", function () {
        $("#btnAddAnother").show();
        showCreateEditProduct();
    });
};

var showCreateEditProduct = function () {
    $("#btnCancel").on("click", function () {
        $("#divCreateEditProduct").modal("hide");
    });

    $("#btnDone").on("click", function (e) {
        submitProductData(true);
    });

    $("#btnAddAnother").on("click", function () {
        submitProductData(false);
    });

    $("#divCreateEditProduct").modal("show");
};

var submitProductData = function (hideDialog) {

    if ($("#selSuppliers").val() === "") {
        showMsg("Please select a supplier", MsgType.warning)
        return false;
    }

    if ($("#inputProductCode").val() === "") {
        showMsg("Please enter a Product Code", MsgType.warning)
        return false;
    }
    if ($("#inputProductName").val() === "") {
        showMsg("Please enter a Product Name", MsgType.warning)
        return false;
    }
    if ($("#inputProductPrice").val() === "") {
        showMsg("Please enter a Product Price.", MsgType.warning)
        return false;
    }

    var form = document.forms["frmProduct"];

    var productViewModel = {};
    productViewModel.ProductCode = form.elements["inputProductCode"].value;
    productViewModel.ProductName = form.elements["inputProductName"].value;
    productViewModel.ProductID = form.elements["hfProductId"].value;
    productViewModel.ProductPrice = form.elements["inputProductPrice"].value;
    productViewModel.SupplierID = Number.parseInt($("#selSuppliers").val());

    ajaxHelper($("#hfUrl").val(), "POST", null, productViewModel, function () {
        document.forms["frmProduct"].reset();
        showMsg("Successfull", MsgType.success);
        if (hideDialog)
            $("#divCreateEditProduct").modal("hide");
        ProductTable.ajax.reload();
    });
};