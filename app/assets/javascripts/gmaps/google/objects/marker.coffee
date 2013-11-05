class @Gmaps.Google.Objects.Marker extends Gmaps.Base

  @include Gmaps.Google.Objects.Common

  constructor: (@serviceObject, @infowindow)->

  updateBounds: (bounds)->
    bounds.extend(@getServiceObject().position)

  panTo: ->
    @getServiceObject().getMap().panTo @getServiceObject().getPosition()

  click: ->
    google.maps.event.trigger(@getServiceObject(), 'click')
  
  clear: ->
    @getServiceObject().setMap(null)
    @getServiceObject().serviceObject = null

  show: ->
    @getServiceObject().setVisible(true)

  hide: ->
    @getServiceObject().setVisible(false)
