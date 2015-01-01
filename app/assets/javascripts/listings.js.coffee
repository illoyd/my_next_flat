# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

mapify = (map) ->
  map.gmap(
    center: map.data('lat') + ',' + map.data('lon')
  ).bind 'init', ->
    markerify(map, $(marker)) for marker in $('[data-map='+map.data('map-id')+']')
    fit_map(map)


markerify = (map, marker) ->
  map.gmap('addMarker', {
    position:  marker.data('lat') + ',' + marker.data('lon'),
    animation: google.maps.Animation.DROP,
    draggable: false
  }).click ->
    $('html, body').animate({
      scrollTop: $('#' + marker.data('jump')).offset().top - 70
    }, 1250);
    # window.location = '#' + marker.data('jump');
    # $('#' + marker.data('jump')).get(0).scrollIntoView();
    # map.gmap('openInfoWindow', {content: marker.get(0)}, this)


fit_map = (map) ->
  markers = map.gmap('get', 'markers')
  bounds  = new google.maps.LatLngBounds()
  bounds.extend(marker.getPosition()) for marker in markers
  
  gmap = map.gmap('get', 'map')
  gmap.fitBounds(bounds)
  gmap.setZoom(15) if gmap.getZoom() > 15


$(document).on 'page:change', ->
  $("div[data-map-id]").each (index) ->
    mapify($(this))
