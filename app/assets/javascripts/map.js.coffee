Gmaps.store = {} #handler, markers, userPin, eventPin
jQuery ->
  Gmaps.store.handler = Gmaps.build 'Google'
  Gmaps.store.handler.buildMap { internal: {id: 'map'} }, ->
    positionSuccess = (position) ->
      userLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      Gmaps.store.handler.map.centerOn
        lat: position.coords.latitude
        lng: position.coords.longitude
      updateUserMarker userLocation
      year = new Date().getFullYear()
      month =  new Date().getMonth()+1
      day = new Date().getDate()
      $.ajax(
        dataType: 'script'
        data:
          lat: position.coords.latitude
          lng: position.coords.longitude
          date: year+'-'+month+'-'+day
        type: 'GET'
        url: '/find-events'
      )
      
    positionError = (error) ->
      switch error.code
        when error.PERMISSION_DENIED
          alert "User denied the request for Geolocation."
        when error.POSITION_UNAVAILABLE
          alert "Location information is unavailable."
        when error.TIMEOUT
          alert "The request to get user location timed out."
        when error.UNKNOWN_ERROR
          alert "An unknown error occurred."

    geoOptions =
      enableHighAccuracy: true
      timeout: 5000

    navigator.geolocation.getCurrentPosition(positionSuccess, positionError, geoOptions)

    Gmaps.store.circles = Gmaps.store.handler.addCircles(
    )

    google.maps.event.addListener Gmaps.store.handler.getMap(), 'click', (event) ->
      updateEventMarker event.latLng if $('#createEventWindow').is(':visible')
      
      
