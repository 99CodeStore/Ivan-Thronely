"use strict";

var SupplierTable;

$(document).ready(function () {
    iniTblSuppliers();
});

(function () {
    $("#btnCreateNewSupplier").on("click", function () {
        loadCreateNewSupplier();
    });
})();

var iniTblSuppliers = function () {
    SupplierTable = $('#tblSuppliers').DataTable({
        "responsive": true,
        "processing": true,
        "ajax": {
            "url": "/Supplier/GetSuppliers",
            "type": "GET",
            "dataType": "json",
            "headers": {
                "RequestVerificationToken": $("[name=__RequestVerificationToken]").val().toString()
            },
            "dataSrc": (json) => {
                return json;
            },
        },
        "columns": [
            { "data": "supplierCode", "name": "supplierCode", "title": "Code" },
            { "data": "supplierName", "name": "supplierName", "title": "Name" },
            {
                "data": null, "name": "action", "title": "", "width": '20%', "render": (data, type, row) => {
                    return `
                                      <button type="button" data-id="${data.supplierID}" class="btn btn-primary btnEditSupplier">Edit</button>
                                      <button type="button" data-id="${data.supplierID}" class="btn btn-danger btnRemoveSupplier">Remove</button>
                            `;
                }
            }
        ]
    });

    $("#tblSuppliers tbody").on("click", ".btnEditSupplier", function (event) {
        loadEditSupplier($(this).data("id"));
    });

    $("#tblSuppliers tbody").on("click", ".btnRemoveSupplier", function (event) {
        $("#confirmationModal").modal("show");
        $("#btnConfirmationProceed").html(`<button id="btnDeleteSupplier" data-id="${$(this).data("id")}" type="button" class="btn btn-primary">Proceed</button>`);

        $("#btnDeleteSupplier").on("click", function () {
            ajaxHelper("/Supplier/DeleteSupplier", "POST", null, $(this).data("id"), function () {
                showMsg("Successfull", MsgType.success);
                $("#confirmationModal").modal("hide");
                SupplierTable.ajax.reload();
            });
        });
    });
};

var loadEditSupplier = function (id) {
    LoadPartial("#createEditView", "Supplier", "EditSupplier", `?supplierId=${id}`, function () {
        $("#btnAddAnother").hide();
        showCreateEditSupplier();
    });
};

var loadCreateNewSupplier = function () {
    LoadPartial("#createEditView", "Supplier", "CreateSupplier", "", function () {
        $("#btnAddAnother").show();
        showCreateEditSupplier();
    });
};

var showCreateEditSupplier = function () {
    $("#btnCancel").on("click", function () {
        $("#divCreateEditSupplier").modal("hide");
    });

    $("#btnDone").on("click", function (e) {
        submitSupplierData(true);
    });

    $("#btnAddAnother").on("click", function () {
        submitSupplierData(false);
    });

    $("#divCreateEditSupplier").modal("show");
};

var submitSupplierData = function (hideDialog) {


    if ($("#inputSupplierCode").val() === "") {
        showMsg("Please enter a supplier Code", MsgType.warning)
        return false;
    }
    if ($("#inputSupplierName").val() === "") {
        showMsg("Please enter a supplier name", MsgType.warning)
        return false;
    }

    var form = document.forms["frmSupplier"];

    var supplierViewModel = {};
    supplierViewModel.SupplierCode = form.elements["inputSupplierCode"].value;
    supplierViewModel.SupplierName = form.elements["inputSupplierName"].value;
    supplierViewModel.SupplierID = form.elements["hfSupplierId"].value;

    ajaxHelper($("#hfUrl").val(), "POST", null, supplierViewModel, function () {
        document.forms["frmSupplier"].reset();
        showMsg("Successfull", MsgType.success);
        if (hideDialog)
            $("#divCreateEditSupplier").modal("hide");
        SupplierTable.ajax.reload();
    });
}