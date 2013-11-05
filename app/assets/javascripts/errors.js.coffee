jQuery ->
  $('.alert-dismissable').delay(7000).fadeOut 'slow', ->
    $('.alert').parent().parent().remove()

  $('.field_with_errors').parent().addClass 'has-error'

  