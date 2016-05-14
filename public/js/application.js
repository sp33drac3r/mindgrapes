$( document ).ready(function() {
  $('#left-nav').click(function(){
    $('.sidebar')
      .sidebar('toggle')
    ;
  });

  $('.ui.modal')
    .modal('attach events', '#signup-button', 'show')
  ;
});

