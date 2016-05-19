$( document ).ready(function() {

  $(".pointy").click(function(event){
    event.preventDefault()
    var url = $( this ).attr('href')
    $( this ).siblings().removeClass("active")
    $( this ).addClass("active")

    $.get( url, function(data){
      $('.yield').html(data)
    });
  });

  $(".chart").click(function(event) {
    event.preventDefault()
    var url = $( this ).attr('href')
    $( this ).siblings().removeClass("active")
    $( this ).addClass("active")
    $.ajax({
      url: url,
      method: "GET",
    }).done(function( data ) {
      $('.yield').html(data);
      var chart = new Highcharts.Chart({
        chart: {
          renderTo: "time-series-chart",
          backgroundColor: 'transparent',
          color: '#FFF'
        },
        title: {
              text: 'Your Sentiment Over Time',
              x: -20, //center
              style: {
                color: '#FFF'
              }
          },
          subtitle: {
              text: 'Source: text-processing.com',
              x: -20,
              style: {
                color: '#FFF'
              }
          },
          xAxis: {
              categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
              labels: {
                style: {
                  color: '#FFF'
                }
              }
          },
          yAxis: {
              title: {
                  text: 'Sentiment Percentage (0.0 - 1.0)',
                  style: {
                    color: '#FFF'
                   }
              },
              plotLines: [{
                  value: 0,
                  width: 1,
                  color: '#FFF'
              }],
              labels: {
                style: {
                  color: '#FFF'
                }
              }
          },
          tooltip: {
              valueSuffix: '°C'
          },
          legend: {
              layout: 'vertical',
              align: 'right',
              verticalAlign: 'middle',
              borderWidth: 0
          },
          series: [{
              name: 'Positive',
              data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
          }, {
              name: 'Neutral',
              data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
          }, {
              name: 'Negative',
              data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
          }]
      });
    });
  });

  $('.ui.modal').modal('attach events', '#signup-button', 'show');

});
