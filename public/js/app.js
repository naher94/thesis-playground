$(document).foundation()

$(document).keydown(function(e){
  if (e.keyCode == 13) {
    window.location.replace("/")
  }
});
