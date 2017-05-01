$(document).foundation()

var input = document.getElementById('text-field');

input.focus();
input.select();

$(document).keydown(function(e){
  if (e.keyCode == 13) {
    window.location.replace("/")
  }
});

$("#guess").focus();
