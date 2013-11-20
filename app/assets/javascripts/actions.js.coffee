jQuery ->

  $(document).on 'click', '.close', ->
    Gmaps.store.handler.removeMarker Gmaps.store.eventPin if Gmaps.store.eventPin
    $(this).parent().fadeOut -> $(this).html('')

  $(document).on 'focusout', '#createEventWindow #event_location', ->
    typeLocation(this, updateEventMarker)

  $(document).on 'focusout', '#collapseOne input#location', ->
    typeLocation(this, updateUserMarker)

  $(document).on 'click', '#show_events_click', ->
    $('#collapseOne input.btn').click()
    $('#collapseTwo').collapse('show')

  $('#accordion').on 'show.bs.collapse', ->
    $('#accordion .in').collapse('hide')

  $(document).on 'mouseenter', 'input#share_button', ->
    $(this).val('Unshare').removeClass('btn-success').addClass('btn-danger')
    .mouseleave ->
      $(this).val('Sharing').removeClass('btn-danger').addClass('btn-success')
  
  $(document).on 'mouseenter', 'input#go_button', ->
    $(this).val('Nah...').removeClass('btn-success').addClass('btn-danger')
    .mouseleave ->
      $(this).val('Going').removeClass('btn-danger').addClass('btn-success')
  
  $(document).on 'click', '#comment_comment', ->
    $('#comment_comment').keyup ->
      $(this).val($(this).val().replace /^\s+|\s+$/g, "")
      unless $(this).val().length < 10
        $('#comments .btn-primary').attr 'disabled', false
      else
        $('#comments .btn-primary').attr 'disabled', true

  #moves map to marker clicked + open infowindow
  $(document).on 'click', '#sideBar li.sb', ->
    Gmaps.store.markers[$(this).data('marker')].panTo()
    Gmaps.store.markers[$(this).data('marker')].click()

  $('.dateSearch').datepicker
    todayBtn: 'linked'

  # get date from datepicker and pass it to a form
  $('.dateSearch').datepicker().on 'changeDate', ->
    dateObject =  $(this).datepicker('getDate')
    year = dateObject.getFullYear()
    month =  dateObject.getMonth()+1
    day = dateObject.getDate()
    $('#collapseOne input#date').val year+'-'+month+'-'+day

  mapSize()
  $(window).resize ->
    mapSize()

# set size of map
mapSize = ->
  height = $(window).height()
  $('#map').css height: height
  $('#eventWindow').css height: height-120
  $('#sideBar .panel-body').css maxHeight: height*0.6

@showMarkers = ->
  for marker in Gmaps.store.markers
    marker.show()

@hideMarkers = ->
  for marker in Gmaps.store.markers
    marker.hide()

# Update event form attributes with given coordinates
updateEventForm = (latLng) ->
  revGeo = new google.maps.Geocoder()
  revGeo.geocode latLng: latLng, (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      place = results[0].formatted_address if results[0]
      $('#createEventWindow #event_location').val place
      $('#createEventWindow #event_lat').val latLng.lat()
      $('#createEventWindow #event_lng').val latLng.lng()
    else
      alert "Geocoder failed due to: " + status

# event creation... add marker
@updateEventMarker = (latLng) ->
  Gmaps.store.handler.removeMarkers Gmaps.store.markers
  Gmaps.store.handler.removeMarker Gmaps.store.eventPin if Gmaps.store.eventPin
  Gmaps.store.eventPin = Gmaps.store.handler.addMarker(
    { lat: latLng.lat()
    lng: latLng.lng()
    marker_title: 'Event Location... Drag me!'
    picture: 
      anchor: [10,34]
      url: image_path('purple_marker.png')
      width: 20
      height: 34
    shadow:
      anchor: [2,22]
      url: image_path('sprite_shadow.png')
      width: 29
      height: 22 },
    { draggable: true
    animation: google.maps.Animation.DROP }
  )
  updateEventForm latLng
  # Listen to drag & drop
  google.maps.event.addListener Gmaps.store.eventPin.getServiceObject(), "dragend", (event) ->
    updateEventForm event.latLng

# Update user form attributes with given coordinates
updateUserForm = (latLng) ->
  revGeo = new google.maps.Geocoder()
  revGeo.geocode latLng: latLng, (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      place = results[0].formatted_address.split(', ')[1] if results[0]
      $('#collapseOne input#location').val place
      $('#collapseOne input#lat').val latLng.lat()
      $('#collapseOne input#lng').val latLng.lng()
      $('span#userSearch').html place
    else
      alert "Geocoder failed due to: " + status

# user location... add marker
@updateUserMarker = (latLng) ->
  Gmaps.store.handler.removeMarker Gmaps.store.userPin if Gmaps.store.userPin
  Gmaps.store.userPin = Gmaps.store.handler.addMarker(
    { lat: latLng.lat()
    lng: latLng.lng()
    marker_title: 'Your Location... Drag me!'
    picture: 
      anchor: [10,34]
      url: image_path('purple_marker.png')
      width: 20
      height: 34
    shadow:
      anchor: [2,22]
      url: image_path('sprite_shadow.png')
      width: 29
      height: 22 },
    { draggable: true
    animation: google.maps.Animation.BOUNCE }
  )
  Gmaps.store.handler.getMap().setZoom(14)
  updateUserForm latLng
  # Listen to drag & drop
  google.maps.event.addListener Gmaps.store.userPin.getServiceObject(), "dragend", (event) ->
    updateUserForm event.latLng
    $('#collapseOne').collapse('show');

# event searching... find location, move map, set bounds, search bounds
@typeLocation = (input, marker_function)->
  if $(input).val()
    geocoder = new google.maps.Geocoder()
    address = $(input).val()
    geocoder.geocode address: address, (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        latLng = results[0].geometry.location
        marker_function latLng
        Gmaps.store.handler.map.centerOn
          lat: latLng.lat()
          lng: latLng.lng()
      else
        throw status + ' for ' + address


