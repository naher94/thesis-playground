$(document).foundation()

//var input = document.getElementById('text-field').autofocus;

$(function() {
  $("text-field").focus();
});

$(document).keydown(function(e){
  if (e.keyCode == 13) {
    window.location.replace("/sandbox")
  }
});

$("#guess").focus();
