$( document ).ready(function() {

  $("a").click(function( event ) {
    event.preventDefault();
    console.log(this)
    var url = $( this ).attr('href')
    console.log(url)
    // $.get(url, function(data){
    //   // $('.yield').html(data)
    // })
  });

  $(".pointy").click(function(event){
    event.preventDefault()
    var url = $( this ).attr('href')
    $( this ).siblings().removeClass("active")
    $( this ).addClass("active")

    $.get( url, function(data){
      $('.yield').html(data)
    });
  });

  $('.ui.modal').modal('attach events', '#signup-button', 'show');

})

