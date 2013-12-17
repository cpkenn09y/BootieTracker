var gm = google.maps
var markers = [];

var icons = {
  "San Francisco": {
    icon: 'https://s3-us-west-2.amazonaws.com/booty-map/sf.png'
  },
  "Chicago": {
    icon: 'https://s3-us-west-2.amazonaws.com/booty-map/chicago.png'
  }
};

function createMap() {
  var mapOptions = {
    zoom: 6,
    disableDefaultUI: true
  };
  map = new gm.Map(document.getElementById('map-canvas'), mapOptions);
}

function instantiateOMS() {
  oms = new OverlappingMarkerSpiderfier(map)
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
    setPointsOntoMapAndAttachListeners(bootsDataForMap)
  })
}

function setPointsOntoMapAndAttachListeners(bootsDataForMap) {
  for(var i = 0, num = bootsDataForMap.length; i < num; i++) {
    var lat = bootsDataForMap[i].user.latitude
    var lon = bootsDataForMap[i].user.longitude
    var name = bootsDataForMap[i].user.name
    var user = new google.maps.LatLng(lat, lon);

    var marker = new google.maps.Marker({
      position: user,
      title: name,
      icon: icons[bootsDataForMap[i].user.cohort_name.location].icon
    })
    var mcOptions = {gridSize: 20, maxZoom: 15, minimumClusterSize:5};
    markers.push(marker)
    var mc = new MarkerClusterer(map, markers, mcOptions);
    attachListenerOntoMarker(bootsDataForMap[i], marker)

    addMarkerIntoOms(marker)
  }
}

function addMarkerIntoOms(marker) {
  oms.addMarker(marker)
}

function attachListenerOntoMarker(bootData, marker) {
  google.maps.event.addListener(marker, "click", function(event) {
    createInfoWindowUponClick(bootData, marker)
  })
}

function attachListersOntoRadioButtons() {
  $('input:radio').on("change", function(event){
  })
}

function createInfoWindowUponClick(bootData, marker) {
  var contentString = '<div class="content-box">'+
    '<img src='+bootData.user.image_url+'>'+
    '<p>'+bootData.user.name+' | <strong>'+bootData.user.current_location+'</strong></p>'+
    '<a href=mailto:'+bootData.user.email+'>' + bootData.user.email+'</a>'+
    '<p>' +bootData.user.cohort_name.cohort_name+'</p>'
    if (bootData.user.linked_in){
      contentString = contentString + '<a target="_blank" href='+bootData.user.linked_in+'><i class="fa-3x fa fa-linkedin-square"></i>&nbsp</a>'
    }
    if (bootData.user.facebook){
      contentString = contentString + '<a target="_blank" href='+bootData.user.facebook+'><i class="fa-3x fa fa-facebook-square"></i>&nbsp</a>'
    }
    if (bootData.user.github){
      contentString = contentString + '<a target="_blank" href='+bootData.user.github+'><i class="fa-3x fa fa-github-square"></i>&nbsp</a>'
    }
    if (bootData.user.twitter){
      contentString = contentString + '<a target="_blank" href='+bootData.user.twitter+'><i class="fa-3x fa fa-twitter-square"></i>&nbsp</a>'

    }
    if(bootData.user.blog){
    contentString = contentString +  '<a target="_blank" href='+bootData.user.blog+'><i class="fa-3x fa fa-tumblr-square"></i>&nbsp</a>'
    }
    contentString = contentString +  '</div>';

  var infoWindow = new gm.InfoWindow()
  infoWindow.setContent(contentString)
  infoWindow.open(map,marker);
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
  instantiateOMS()
  centersMapOnYourLocation()
  grabBootsDataForMap()
}

$(document).ready(initialize)