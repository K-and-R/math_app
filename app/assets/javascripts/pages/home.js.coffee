window.MATH_APP = window.MATH_APP || {}
window.MATH_APP.pages = window.MATH_APP.pages || {}
window.MATH_APP.pages.home =
  edit: ->
    # Code that runs on edit page
  index: ->
    # Code that runs on index page
  new: ->
    # Code that runs on new page
  shared: ->
    # Code that always runs on all pages
    jQuery ->
      $('a.pjaxed').pjax('[data-pjax-container]')
  show: ->
    # Code that runs on show page
