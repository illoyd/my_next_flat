# Ensure app is available
window.Application ||= {}

scrollOffset = 70
defaultSpeed = 575

# Create add ScrollTo function
Application.scrollTo = (target, speed) ->
  console.log('target = ' + target + ', speed = ' + speed)
  $('html, body').animate({
    scrollTop: $(target).offset().top - scrollOffset
  }, speed)

# Add scrollTo function to click for links with scroll-to data attribute
Application.addScrollTo = ->
  $("a[data-scroll-to]").click ->
    target = if $(this).data('scroll-to') is true then $(this).attr("href") else $(this).data('scroll-to')
    speed  = $(this).data('scroll-speed') || defaultSpeed
    Application.scrollTo(target, speed)
    return false

# Update on page load
$(document).ready(Application.addScrollTo)
$(document).on('page:load', Application.addScrollTo)