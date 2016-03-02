# initialize your global object with all your model names
window.MATH_APP = window.MATH_APP || {}
window.MATH_APP.pages = window.MATH_APP.pages || {}
window.MATH_APP.pages.home = window.MATH_APP.pages.home || {}

# Call the model's action function based on the body class names
((jQuery, EA) ->
  jQuery(document).ready ->
    b = jQuery "body"
    if b.hasClass "edit"
      a = "edit"
    else if b.hasClass "show"
      a = "show"
    else if b.hasClass "index"
      a = "index"
    else if b.hasClass "new"
      a = "new"
    EA.current_action = a
    for c of EA.pages
      if b.hasClass c
        EA.current_controller = c
        if EA.pages[c]['shared'] && typeof EA.pages[c]['shared'] == "function"
          EA.pages[c]['shared']()
        if EA.pages[c][a] && typeof EA.pages[c][a] == "function"
          EA.pages[c][a]()
        break
) jQuery,window.MATH_APP
