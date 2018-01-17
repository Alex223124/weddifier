document.addEventListener 'turbolinks:load', (event) ->
  # Load particles
  if document.querySelector '#particles-js'
    particlesJSONPath = $('#particles-js').data('json-path')
    particlesJS.load 'particles-js', particlesJSONPath

  # Activate Bootstrap tooltip
  $('[data-toggle="tooltip"]').tooltip()
  # Hide form
  $('.half-background').css('opacity', '0')
  $('.js-animate-left').css('opacity', '0')

  # -- Fade effect checks --
  alreadyFaded = false
  pxBeforeToggle = do ->
    # To toggle fadeRegistrationFromLeft earlier on small devices.
    if $(window).width() >= 1500 then 1000 else 300

  # -- Action: Scroll to bottom / Fade in form if form has errors --
  if document.querySelector('.js-signup-form-has-errors') && !document.querySelector('#js-plus-one-container')
    fadeRegistrationFromLeft()
    scrollToBottom()

  if document.querySelector('#js-plus-one-container')
    fadeRegistrationFromLeft()

  # -- Listener: Fade on scroll --
  $(window).on 'scroll', (event) ->
    if $(window).scrollTop() + $(window).height() > $(document).height() - pxBeforeToggle
      unless alreadyFaded == true
        fadeRegistrationFromLeft()

  # -- Listener: Fade on arrow click + Scroll to bottom --
  $('#see-more-arrow-down').on 'click', (event) ->
    scrollToBottom()
    $('#guest_first_name').focus()
    setTimeout(fadeRegistrationFromLeft, 1000)

# -- Function: Fade effect --
fadeRegistrationFromLeft = ->
  $(".half-background").css
    "opacity": "0"
    "left":"-=50"

  $(".half-background").animate
    left: 0
    opacity: 1
  , 1000

  $(".js-animate-left").css
    "position":"relative"
    "opacity": "0"
    "left":"-=50"

  $(".js-animate-left").animate
    left: 0
    opacity: 1
  , 1000

# -- Function: Scroll to bottom --
scrollToBottom = ->
  $('html').animate(scrollTop: window.innerHeight, 1000)
