# Debounce and SmartResize (in jQuery) ported to CoffeeScript
# debouncing function from John Hann
# http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
# https://gist.github.com/coreyward/1114972

window.debounce = (func, threshold, execAsap) ->
  timeout = false

  return debounced = ->
    obj = this
    args = arguments

    delayed = ->
      func.apply(obj, args) unless execAsap
      timeout = null

    if timeout
      clearTimeout(timeout)
    else if (execAsap)
      func.apply(obj, args)

    timeout = setTimeout delayed, threshold || 100

# Smartresize
jQuery.fn['smartresize'] = (fn) ->
  if fn then this.bind('resize', debounce(fn)) else this.trigger('smartresize')
