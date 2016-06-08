window.RSVP = 

  setCookie: (name, value, days) ->
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""
    document.cookie = name + "=" + value + expires + "; path=/"

  getCookie: (name) ->
    nameEQ = name + "="
    ca = document.cookie.split(";")
    i = 0

    while i < ca.length
      c = ca[i]
      c = c.substring(1, c.length)  while c.charAt(0) is " "
      return c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
      i++
    null
      
  deleteCookie: (name) ->
    setCookie name, "", -1


  find: (id) =>
    id = id.toUpperCase()
    if RSVP.validate(id)
      window.RSVP.setCookie "rsvp/invitation_code", id, 100
      window.location.href = "/invitations/#{id}"

  validate: (id) =>
    return id.match(/[A-Z]/) and id.match(/[A-Z]/g).length is id.length and id.length is 6


$(document).ready ->
  updateGuest = (element)->    
    return false if not element
    $(element).parents('label').siblings().removeClass('selected')
    $(element).parents('label').addClass('selected')
    $(element).parents('.field').removeClass('attending not_attending')
    $(element).parents('.field').addClass(element.value)
    if $(element).attr('id') and $(element).attr('id').match /reception/
      if element.value.match /not/
        $('.meals_select, .meals_select *, [for=guest_accommodations], [for=guest_accommodations] *').attr('title', 'You only need a meal choice if you are attending the reception.').removeClass('selected').removeAttr('checked').attr('disabled', 'disabled')
      else
        $('.meals_select, .meals_select *, [for=guest_accommodations], [for=guest_accommodations] *').removeAttr('disabled title')
  if $('#invitation_code') and window.RSVP.getCookie "rsvp/invitation_code"
    $('#invitation_code').val window.RSVP.getCookie "rsvp/invitation_code"
  if $('.guest')
    $($('.guest [checked]').get().reverse()).each ->
      updateGuest this
  $('.meals_select, .guest #ceremony, .guest #reception').delegate 'input', 'change', (e)-> 
    updateGuest this