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

function setPointsOntoMap(all_locations) {
  for(var i = 0, num = all_locations.length; i < num; i++) {
    var lat = all_locations[i].user_name.latitude
    var lon = all_locations[i].user_name.longitude
    var name = all_locations[i].user_name.name
    var user = new google.maps.LatLng(lat, lon);
    var marker = new google.maps.Marker({
      position: user,
      title: name
    })
    marker.setMap(map);
  }
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
  all_locations = grabBootsDataForMap()
}

$(document).ready(initialize)

  // google.maps.event.addDomListener(window, 'load', initialize);