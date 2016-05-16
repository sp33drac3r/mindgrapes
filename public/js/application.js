$( document ).ready(function() {
  $('#sidebar-icon').click(function(){

    $('.sidebar')
      .sidebar('toggle')
    ;
  });

  $(".ui.pointing.menu a").click(function(event){
    event.preventDefault()
    var url = $( this ).attr('href')
    $( this ).siblings().removeClass("active")
    $( this ).addClass("active")
    console.log( url )
    $.get( url, function(data){
      $('.yield').html(data)
    });
  });

  $('.ui.modal')
    .modal('attach events', '#signup-button', 'show')
  ;
});

