jQuery ->
  $('.alert-dismissable').delay(7000).fadeOut 'slow', ->
    $('.alert').parent().remove()

  