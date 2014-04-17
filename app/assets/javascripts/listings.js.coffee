# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

mapify = (map) ->
  map.gmap(
    center: map.data('latitude') + ',' + map.data('longitude')
  ).bind 'init', ->
    markerify(map, $(marker)) for marker in $('div[data-marker='+map.data('mapify')+']')
    fit_map(map)


markerify = (map, marker) ->
  map.gmap('addMarker', {
    position: marker.data('latitude') + ',' + marker.data('longitude'),
    animation: google.maps.Animation.DROP,
    draggable: false
  } ).click ->
    map.gmap('openInfoWindow', {content: marker.get(0)}, this)


fit_map = (map) ->
  markers = map.gmap('get', 'markers')
  bounds  = new google.maps.LatLngBounds()
  bounds.extend(marker.getPosition()) for marker in markers
  
  gmap = map.gmap('get', 'map')
  gmap.fitBounds(bounds)
  gmap.setZoom(15) if gmap.getZoom() > 15


$(document).ready ->
  $("div[data-mapify]").each (index) ->
    mapify($(this))
