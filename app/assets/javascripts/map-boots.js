var map;

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
    marker.setMap(map);
    attachListenerOntoMarker(bootsDataForMap[i], marker)
  }
  attachListersOntoRadioButtons()
}

function attachListenerOntoMarker(bootData, marker) {
  google.maps.event.addListener(marker, "click", function(event) {
    createInfoWindowUponHover(bootData, marker)
  })
}

function attachListersOntoRadioButtons() {
  $('input:radio').on("change", function(event){
    console.log(event)
    debugger
  })
}

function createInfoWindowUponHover(bootData, marker) {
  var contentString = '<div class="content-box">'+
    '<img src='+bootData.user.image_url+'>'+
    '<p>'+bootData.user.name+' | <strong>'+bootData.user.current_location+'</strong></p>'+
    '<a href=mailto:'+bootData.user.email+'><i class="fa-3x fa fa-envelope-o"></i>'+bootData.user.email+'</a>'+
    '<p><i class="fa-3x fa fa-linux"></i>'+bootData.user.cohort_name.cohort_name+'</p>'
    if (bootData.user.linked_in){
      contentString = contentString + '<a href='+bootData.user.linked_in+'target="_blank"><i class="fa-3x fa fa-linkedin-square"></i>&nbsp</a>'
    }
    if (bootData.user.facebook){
      contentString = contentString + '<a href='+bootData.user.facebook+'target="_blank"><i class="fa-3x fa fa-facebook-square"></i>&nbsp</a>'
    }
    if (bootData.user.github){
      contentString = contentString + '<a href='+bootData.user.github+'target="_blank"><i class="fa-3x fa fa-github-square"></i>&nbsp</a>'
    }
    if (bootData.user.twitter){
      contentString = contentString + '<a href='+bootData.user.twitter+'target="_blank"><i class="fa-3x fa fa-twitter-square"></i>&nbsp</a>'

    }
    if(bootData.user.blog){
    contentString = contentString +  '<a href='+bootData.user.blog+'target="_blank"><i class="fa-3x fa fa-tumblr-square"></i>&nbsp</a>'
    }
    contentString = contentString +  '</div>';

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