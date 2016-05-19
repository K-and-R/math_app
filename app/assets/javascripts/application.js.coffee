# This is a manifest file that'll be compiled into application.js, which will
# include all the files listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts,
# vendor/assets/javascripts, or vendor/assets/javascripts of plugins, if
# any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear
# at the bottom of the compiled file.
#
# For details about supported directives, read Sprockets README:
# (https:#github.com/sstephenson/sprockets#sprockets-directives)
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE
# PROCESSED, ANY BLANK LINE SHOULD GO AFTER THE REQUIRES BELOW.
#
#= require jquery_ujs
#= require jquery.pjax
#= require jquery.datetimepicker.min
#= require jquery.dateFormat.min
#= require jquery.cookie
#= require dependent-select
#= require jstz
#= require app
#= require ./pages/init
#= require_tree ./pages

window.MATH_APP = window.MATH_APP || {}

((jQuery, jstz, EA) ->
  jQuery(document).on 'click', '.back-button', -> history.go(-1)

  # Store the user's timezone in a cookie so we can use it.
  # https:#github.com/vanetten/jstz-rails
  timezone = jstz.determine()
  jQuery.cookie 'time_zone', timezone.name(), { path:'/' } if timezone

  jQuery(document).ready ->
    # Set selected nav item
    jQuery('#main-nav a[href$="' + window.location.pathname + '"]')
      .each (index) ->
        jQuery(@).parent().addClass 'selected'

    jQuery('[data-toggle="tooltip"]').tooltip()

    # create datepickers
    jQuery('.datepicker_field').datetimepicker
      minDate: '1950/01/01',
      maxDate: 0,
      format: 'Y-m-d'

    jQuery(document).on 'click','#toggle_password_visibility', (event) ->
      event.preventDefault()
      button = jQuery(@)
      icon = button.find('.fa')
      text = button.find('.text')
      if button.data('status') == 'hidden'
        button.data('status', 'visible')
        jQuery('#new_user').find('input[type=password], input[type=text]').each ->
          jQuery(this).attr('type', 'text')
        text.text(text.text().replace('Show', 'Hide'))
        icon.addClass('fa-eye-slash')
        icon.removeClass('fa-eye')
      else
        button.data('status', 'hidden')
        jQuery('#new_user').find('input[type=password], input[type=text]').each ->
          jQuery(this).attr('type', 'password')
        text.text(text.text().replace('Hide', 'Show'))
        icon.addClass('fa-eye')
        icon.removeClass('fa-eye-slash')
  true
) jQuery,jstz,window.MATH_APP
