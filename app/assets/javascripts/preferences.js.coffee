# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


change_state = () ->
  $('#step1').hide()
  $('#step2').fadeIn()


jQuery ($) ->
  state = 1
  $('#step2').hide()
  $('#step3').hide()
  $('#btn_step1').click =>
    state++
    change_state
    return
  $('#btn_step2_bk').click =>
    $('#step2').hide()
    $('#step1').fadeIn()
  $('#btn_step2').click =>
    $('#step2').hide()
    $('#step3').fadeIn()
