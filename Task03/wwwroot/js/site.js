var MsgType;

!function (e) {
    e[e.success = 0] = "success",
    e[e.warning = 1] = "warning",
    e[e.error = 2] = "error"
}(MsgType || (MsgType = {}));

function LoadPartial(container, controller, action, params, callback) {
    var jqxhr = $.ajax({
        "url": "/" + controller + "/" + action + params,
        "data": null,
        "success": function (result) {
            $(container).html(result);
            callback();
        },
        "dataType": "html",
        "headers": {
            "RequestVerificationToken": $("[name=__RequestVerificationToken]").val().toString()
        },
        "error": (jqXHR, textStatus, errorThrown) => {
            console.log(jqXHR);
        }
    });
};

async function ajaxHelper(urlCal, typeCal, headerParams, dataCal, callback) {
    return await $.ajax({
        "url": urlCal,
        "type": typeCal,
        "contentType": "application/json; charset=utf-8",
        "dataType": "json",
        "data": JSON.stringify(dataCal),
        "headers": {
            "RequestVerificationToken": $("[name=__RequestVerificationToken]").val().toString(),
            headerParams
        },
        "success": callback,
        "error": (jqXHR, textStatus, errorThrown) => {

            showMsg(jqXHR.responseJSON, MsgType.error);
        }
    });
};

async function showMsg(msg, msgType, msgOptions = null) {
    if (msgOptions !== null) {
        toastr.options = msgOptions;
    }
    else {
        toastr.options = null;
    }

    if (msgType === MsgType.success) {
        toastr.success(msg);
    }

    if (msgType === MsgType.warning) {
        toastr.warning(msg);
    }

    if (msgType === MsgType.error) {
        toastr.error(msg);
    }
}