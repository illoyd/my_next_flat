function get_map(id) {
  return $(id).gmap('get', 'map');
};

function get_map_markers(id) {
  return $(id).gmap('get','markers');
};

function create_map(id, latitude, longitude) {
  return $(id).gmap({'center': latitude + ',' + longitude });
};

function create_home_map(id, latitude, longitude) {
  create_map(id, latitude, longitude);
  var map = get_map(id);

  // Attach header
  var header = $('#header');
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(header.get(0));

  // Attach footer
  var footer = $('#footer');
  map.controls[google.maps.ControlPosition.BOTTOM_CENTER].push(footer.get(0));
}

function add_marker(id, latitude, longitude, content_id) {
  $(id).gmap('addMarker', { 'position': latitude + ',' + longitude }).click(function() {
		$(id).gmap('openInfoWindow', {'content': $(content_id).get(0)}, this);
	});
};

function fit_map(id) {
  var markers = get_map_markers(id);
  var bounds  = new google.maps.LatLngBounds();
  for(ii = 0; ii < markers.length; ii++) { bounds.extend(markers[ii].getPosition()); }
  get_map(id).fitBounds(bounds);
};
