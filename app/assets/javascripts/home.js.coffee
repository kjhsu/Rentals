# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->
  $('#start_date').datepicker()
  $('#start_date').datepicker('option', $.datepicker.regional['zh-CN'])
  $('#end_date').datepicker()
  $('#end_date').datepicker('option', $.datepicker.regional['zh-CN'])
