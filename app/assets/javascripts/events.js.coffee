jQuery ->
  $(document).on 'click', '.evtwin', ->
    $('#eventWindow').fadeIn()

  $(document).on 'click', '.close', ->
    $(this).parent().fadeOut -> $(this).html('')

  $(document).on 'click', '.newEvent', ->
    $('#createEventWindow').fadeIn()

  $('.input-daterange').datepicker {}

  $('.dateSearch').datepicker {
    todayBtn: 'linked'
  }

  # get date from datepicker and pass it to a form
  $('.dateSearch').datepicker().on 'changeDate', ->
    dateObject =  $(this).datepicker('getDate')
    year = dateObject.getUTCFullYear()
    month =  dateObject.getUTCMonth()+1
    day = dateObject.getUTCDate()
    $('#collapseOne input#date').val year+'-'+month+'-'+day

  mapSize()
  $(window).resize ->
    mapSize()

# set size of map
mapSize = ->
  height = $(window).height()
  $('#map').css height: height
  $('#eventWindow').css height: height*0.96

@clearMarkers = ->
  for marker in Gmaps.store.markers
    marker.clear()
  Gmaps.store.markers = []
  
@showMarkers = ->
  for marker in Gmaps.store.markers
    marker.show()

@hideMarkers = ->
  for marker in Gmaps.store.markers
    marker.hide()