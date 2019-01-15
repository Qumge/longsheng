// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

// This file includes the common AdminLTE JS files that is commonly used on every page

//= require jquery
//= require dist/adminlte
//= require dist/adminlte_extra
//= require dashboard_v1
//= require uielements_icons
//= require plupload/js/moxie
//= require plupload/js/plupload.dev


var initPage = function () {
    $(".modal").on("hidden.bs.modal", function() {
        $(this).removeData("bs.modal");
    });
}

$(document).ready(initPage);
// $(document).on("turbolinks:load", initPage);


$('.show-file').click(function(e){
    var filename = $(this).attr('data-file-name');
    var url = $(this).attr('data-url');
    var ext = filename.split('.').pop();
    // word ppt xls 使用微软在线编辑
    // pdf 使用
    $('#file-modal-label').text($(this).attr('data-file-name'));
    console.log(ext);
    if(['docx', 'doc', 'ppt', 'pptx', 'xls', 'xlsx'].indexOf(ext) >= 0){
       $('#file-modal-body').html("<iframe src='https://view.officeapps.live.com/op/embed.aspx?src=" + url +"' width='100%' height='100%' frameborder='0'></iframe>");
    }else if(['pdf'].indexOf(ext) >= 0){
        // $('#file-modal-body').html("<iframe src='" + url + "' width='100%' height='100%' frameborder='1'>\n");
        $('#file-modal-body').html("<iframe src='/pdfjs/web/viewer.html?file=" + url + "' width='100%' height='100%' frameborder='0' scrolling='no'></iframe>");
    }
    $('#file-modal').modal();
});