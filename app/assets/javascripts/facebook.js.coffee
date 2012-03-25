# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

jQuery ($) ->
  $('[id^=invite_user_]').click ->

    $dialog = $('<div></div>')
         .html('<iframe src="https://www.facebook.com/dialog/send?app_id=158293190926436&
         name=People%20Argue%20Just%20to%20Win&
         link=http://www.nytimes.com/2011/06/15/arts/people-argue-just-to-win-scholars-assert.html&
         redirect_uri=http://localhost:3000
         " height="500" width="500" />')
         .dialog(autoOpen: false, title: 'Test')
    $dialog.dialog('open')
    return false
    # $.get('/friends/invite/' + $(this).attr('facebook_identifier'))
    # $(this).addClass('disabled')
    # $(this).text('Sent')
