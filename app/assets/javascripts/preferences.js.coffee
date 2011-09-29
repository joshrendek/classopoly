# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

Array::remove = (v) -> $.grep @,(e)->e!=v


class Preferences
  class_time: ''
  lunch_time: ''
  work_times: []
  setClassTime: (time) ->
    @class_time = time
  setLunchTime: (time) ->
    @lunch_time = time
  printTimes: () ->
    alert @class_time + '\n' + @lunch_time
  printWorkTimes: () ->
    alert @work_times.toString()
  appendWork: (day) ->
    Array::push.apply @work_times, [day]
  removeWork: (day) ->
    @work_times = @work_times.remove(day)



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
  pref = new Preferences
  $('#t_morning').click =>
    pref.setClassTime('morning')
  $('#t_afternoon').click =>
    pref.setClassTime('afternoon')
  $('#t_evening').click =>
    pref.setClassTime('evening')

  $('#choose_morning').click =>
    $('#time_choice').html("Thanks! We'll remember that you're a <b>morning</b> person in mind when we plan your schedule.")

  $('#choose_afternoon').click =>
    $('#time_choice').html("Thanks! We'll remember that you're a <b>afternoon</b> person in mind when we plan your schedule.")

  $('#choose_evening').click =>
    $('#time_choice').html("Thanks! We'll remember that you're a <b>evening</b> person in mind when we plan your schedule.")

  state = 1
  change_state(state)
  $('#btn_step1').click =>
    if pref.class_time.length == 0
      alert 'Oops! You need to let us know when you prefer to take your classes'
    else
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
    pref.setLunchTime($('#lunch_time_4i').val() + ':' + $('#lunch_time_5i').val())
    $('#step2').hide()
    $('#step3').fadeIn()

  $('#save_preferences').click =>
    pref.printTimes()
    pref.printWorkTimes()


  $('#yes_monday').click =>
    pref.appendWork('monday')
    
  $('#yes_tuesday').click =>
    pref.appendWork('tuesday')
  $('#yes_wednesday').click =>
    pref.appendWork('wednesday')
  $('#yes_thursday').click =>
    pref.appendWork('thursday')
  $('#yes_firday').click =>
    pref.appendWork('friday')

  $('#no_monday').click =>
    pref.removeWork('monday')
    $('#hidden_monday').slideUp()
    $('#yes_monday').fadeIn()
  $('#no_tuesday').click =>
    pref.removeWork('tuesday')
    $('#hidden_tuesday').slideUp()
    $('#yes_tuesday').fadeIn()
  $('#no_wednesday').click =>
    pref.removeWork('wednesday')
    $('#hidden_wednesday').slideUp()
    $('#yes_wednesday').fadeIn()
  $('#no_thursday').click =>
    pref.removeWork('thursday')
    $('#hidden_thursday').slideUp()
    $('#yes_thursday').fadeIn()
  $('#no_friday').click =>
    pref.removeWork('friday')
    $('#hidden_friday').slideUp()
    $('#yes_friday').fadeIn()
