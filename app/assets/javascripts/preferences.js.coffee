# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


change_state = (state) ->
  switch state
    when 1
      $('#step2').hide()
      $('#step3').hide()
      $('#step1').fadeIn()
    when 2
      $('#step1').hide()
      $('#step3').hide()
      $('#step2').fadeIn()
    when 3
      $('#step1').hide()
      $('#step2').hide()
      $('#step3').fadeIn()


jQuery ($) ->
  state = 1
  change_state(state)
  $('#btn_step1').click =>
    state++
    change_state(state)
  $('#btn_step2_bk').click =>
      state--
      change_state(state)
  $('#btn_step3_bk').click =>
      state--
      change_state(state)
  $('#btn_step2').click =>
    state++
    $('#step2').hide()
    $('#step3').fadeIn()

