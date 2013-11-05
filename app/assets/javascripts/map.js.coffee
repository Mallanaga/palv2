Gmaps.store = {} #handler, markers, userPin
jQuery ->
  Gmaps.store.handler = Gmaps.build 'Google'
  Gmaps.store.handler.buildMap { 
    provider: { 
      minZoom: 3
    }, internal: {id: 'map'} }, ->
      positionSuccess = (position) ->
        userLocation = new google.maps.LatLng(position.coords.latitude + ',' + position.coords.longitude)
        Gmaps.store.handler.map.centerOn
          lat: position.coords.latitude
          lng: position.coords.longitude
        Gmaps.store.userPin = Gmaps.store.handler.addMarker(
          { lat: position.coords.latitude
          lng: position.coords.longitude
          marker_title: 'Location... Drag me!'
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

      Gmaps.store.markers = Gmaps.store.handler.addMarkers( $('#map').data('events'), 
        draggable: false
        flat: false
        animation: google.maps.Animation.DROP
      )

      #moves map to marker clicked + open infowindow
      $(document).on 'click', '#sideBar li', ->
        Gmaps.store.markers[$(this).data('marker')].panTo()
        Gmaps.store.markers[$(this).data('marker')].click()
        
        
        