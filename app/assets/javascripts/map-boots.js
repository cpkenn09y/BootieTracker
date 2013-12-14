var map;

function createMap() {
  var mapOptions = {
    zoom: 6
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

function centersMapOnYourLocation() {
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
       position.coords.longitude);

      var infowindow = new google.maps.InfoWindow({
        map: map,
        position: pos,
        content: 'Your Location'
      });

      map.setCenter(pos);
    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }
}

function grabBootsDataForMap() {
  $.getJSON("/maps/index", function(bootsDataForMap) {
    setPointsOntoMap(bootsDataForMap)
  })
}

function setPointsOntoMap(bootsDataForMap) {
  for(var i = 0, num = bootsDataForMap.length; i < num; i++) {
    var lat = bootsDataForMap[i].user.latitude
    var lon = bootsDataForMap[i].user.longitude
    var name = bootsDataForMap[i].user.name
    var user = new google.maps.LatLng(lat, lon);
    var marker = new google.maps.Marker({
      position: user,
      title: name
    })
    marker.setMap(map);
    attachListenerOntoMarker(bootsDataForMap[i], marker)
  }
}

function attachListenerOntoMarker(bootData, marker) {
  google.maps.event.addListener(marker, "mouseover", function(event) {
    console.log(bootData)
    console.log(marker)
    // debugger

    createInfoWindowUponHover(bootData, marker)
  })
}

function createInfoWindowUponHover(bootData, marker) {
  var contentString = '<div class="content-box">'+
    '<p>'+bootData.user.name+'</p>'+
    '<a href=mailto:'+bootData.user.email+'><i class="fa fa-envelope-o"></i>'+bootData.user.email+'</a>'+
    '<p><i class="fa fa-linux"></i>'+bootData.user.cohort_name+'</p>'+
    '<a href='+bootData.user.linked_in+'target="_blank"><i class="fa fa-linkedin-square"></i>&nbsp</a>'+
    '<a href='+bootData.user.github+'target="_blank"><i class="fa fa-github-square"></i>&nbsp</a>'+
    '<a href='+bootData.user.facebook+'target="_blank"><i class="fa fa-facebook-square"></i>&nbsp</a>'+
    '<a href='+bootData.user.twitter+'target="_blank"><i class="fa fa-twitter-square"></i>&nbsp</a>'+
    '<a href='+bootData.user.blog+'target="_blank"><i class="fa fa-tumblr-square"></i>&nbsp</a>'+
  '</div>';

  var infowindow = new google.maps.InfoWindow({
    content: contentString
  });

  infowindow.open(map,marker);
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }
  var options = {
    map: map,
    position: new google.maps.LatLng(60, 105),
    content: content
  };
  var infowindow = new google.maps.InfoWindow(options);
  map.setCenter(options.position);
}

function initialize() {
  createMap()
  centersMapOnYourLocation()
  grabBootsDataForMap()
}

$(document).ready(initialize)

  // google.maps.event.addDomListener(window, 'load', initialize);