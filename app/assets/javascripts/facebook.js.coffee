# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

jQuery ($) ->
  $('[id^=invite_user_]').click ->
    $.get('/friends/invite/' + $(this).attr('facebook_identifier'))
    $(this).addClass('disabled')
    $(this).text('Sent')
