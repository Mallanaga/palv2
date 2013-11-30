jQuery ->
  $('.alert-dismissable').delay(7000).fadeOut 'slow', ->
    $('.alert').parent().remove()

  $(document).on 'click', '.panel-title a', ->
    $('.alert').parent().remove()
  