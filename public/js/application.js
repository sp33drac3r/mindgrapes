var data = {}
var chart
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

  $(".yield").on('click', '.post', function(event) {
    event.preventDefault()
    var url = $( this ).attr('href')

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
      url: '/data',
      method: "GET",
      async: false
    }).done(function( data_response ) {
      data = JSON.parse( data_response)
    });

    $.ajax({
      url: url,
      method: "GET",
    }).done(function( chart_response ) {
      $('.yield').html( chart_response );
      var chart = new Highcharts.Chart({
        chart: {
          renderTo: "time-series-chart",
          type: 'column',
          backgroundColor: 'transparent',
          color: '#FFF'
        },
        credits: {
          enabled: false
        },
        exporting: {
          enabled: false
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
              categories: data.categories,
              labels: {
                style: {
                  color: '#FFF'
                }
              }
          },
          yAxis: {
            min: 0,
            // max: 1,
            labels: {
                style: {
                  color: '#FFF'
                }
              },
              title: {
                  text: 'Sentiment',
                  style: {
                    color: '#FFF'
                   }
              },
             stackLabels: {
                enabled: false,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
          },
          legend: {
              layout: 'vertical',
              align: 'right',
              verticalAlign: 'middle',
              borderWidth: 0,
              itemStyle: {
                color: 'white'
              }
          },
          tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
        },
          plotOptions: {
              column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: false,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: {
                        textShadow: '0 0 3px black'
                    }
                },
                  cursor: 'pointer',
                  point: {
                      events: {
                          click: function(event) {
                            $.ajax({
                              url: '/data/' + this.category,
                              method: "GET",
                            }).done(function( post_response ) {
                              $('.yield').html(post_response)
                            });
                          }
                      }
                  },
                  marker: {
                      lineWidth: 1
                  }
              }
          },
          series: [{
              name: 'Positive',
               color: '#ff8a65',
              data: data.positive,
          }, {
              name: 'Neutral',
              color: '#607d8b',
              data: data.neutral
          }, {
              name: 'Negative',
              color: '#0288d1',
              data: data.negative
          }]
      });
    });
  });

  $('.ui.modal').modal('attach events', '#signup-button', 'show');

});



// '=================== Highcharts Test Chart ===================='

// $(function () {
//     $('#container').highcharts({
//         chart: {
//             type: 'column'
//         },
//         title: {
//             text: 'Stacked column chart'
//         },
//         xAxis: {
//             categories: ['Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas']
//         },
//         yAxis: {
//             min: 0,
//             title: {
//                 text: 'Total fruit consumption'
//             },
//             stackLabels: {
//                 enabled: true,
//                 style: {
//                     fontWeight: 'bold',
//                     color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
//                 }
//             }
//         },
//         legend: {
//             align: 'right',
//             x: -30,
//             verticalAlign: 'top',
//             y: 25,
//             floating: true,
//             backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
//             borderColor: '#CCC',
//             borderWidth: 1,
//             shadow: false
//         },
//         tooltip: {
//             headerFormat: '<b>{point.x}</b><br/>',
//             pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
//         },
//         plotOptions: {
//             column: {
//                 stacking: 'normal',
//                 dataLabels: {
//                     enabled: true,
//                     color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
//                     style: {
//                         textShadow: '0 0 3px black'
//                     }
//                 }
//             }
//         },
//         series: [{
//             name: 'John',
//             data: [5, 3, 4, 7, 2]
//         }, {
//             name: 'Jane',
//             data: [2, 2, 3, 2, 1]
//         }, {
//             name: 'Joe',
//             data: [3, 4, 4, 2, 5]
//         }]
//     });
// });


// '=================== Saved Chart ===================='


//  var chart = new Highcharts.Chart({
//         chart: {
//           renderTo: "time-series-chart",
//           backgroundColor: 'transparent',
//           color: '#FFF'
//         },
//         credits: {
//           enabled: false
//         },
//         exporting: {
//           enabled: false
//         },
//         title: {
//               text: 'Your Sentiment Over Time',
//               x: -20, //center
//               style: {
//                 color: '#FFF'
//               }
//           },
//           subtitle: {
//               text: 'Source: text-processing.com',
//               x: -20,
//               style: {
//                 color: '#FFF'
//               }
//           },
//           xAxis: {
//               categories: data.categories,
//               labels: {
//                 style: {
//                   color: '#FFF'
//                 }
//               }
//           },
//           yAxis: {
//             min: 0,
//             max: 1,
//               title: {
//                   text: 'Sentiment Percentage (0.0 - 1.0)',
//                   style: {
//                     color: '#FFF'
//                    }
//               },
//               plotLines: [{
//                   value: 0,
//                   width: 1,
//                   color: '#FFF'
//               }],
//               labels: {
//                 style: {
//                   color: '#FFF'
//                 }
//               }
//           },
//           legend: {
//               layout: 'vertical',
//               align: 'right',
//               verticalAlign: 'middle',
//               borderWidth: 0,
//               itemStyle: {
//                 color: 'white'
//               }
//           },
//           plotOptions: {
//               series: {
//                   cursor: 'pointer',
//                   point: {
//                       events: {
//                           click: function(event) {
//                             $.ajax({
//                               url: '/data/' + this.category,
//                               method: "GET",
//                             }).done(function( post_response ) {
//                               $('.yield').html(post_response)
//                             });
//                           }
//                       }
//                   },
//                   marker: {
//                       lineWidth: 1
//                   }
//               }
//           },
//           series: [{
//               name: 'Positive',
//                color: '#ff8a65',
//               data: data.positive,
//           }, {
//               name: 'Neutral',
//               color: '#607d8b',
//               data: data.neutral
//           }, {
//               name: 'Negative',
//               color: '#0288d1',
//               data: data.negative
//           }]
//       });
