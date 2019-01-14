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