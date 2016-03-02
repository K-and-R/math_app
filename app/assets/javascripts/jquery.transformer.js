// # These are the properties you could get
// # initials = {
// #   perspective: 0
// #   rotation: 0
// #   rotationX: 0
// #   rotationY: 0
// #   scaleX: 1
// #   scaleY: 1
// #   scaleZ: 1
// #   skewX: 0
// #   skewY: 0
// #   x: 0
// #   y: 0
// #   z: 0
// #   zOrigin: 0
// # }
(function() {
  (function($, TweenMax) {
    return $.prototype.transform = function(prop, value) {
      var target;
      if (prop == null) {
        return this.css('transform');
      } else if (!prop) {
        this.css('transform', 'none');
        return this;
      }
      if (value != null) {
        target = {};
        target[prop] = value;
        TweenMax.set(this, target);
        return this;
      } else {
        if (this[0]._gsTransform == null) {
          TweenMax.set(this, {
            x: '+=0'
          });
        }
        return this[0]._gsTransform[prop];
      }
    };
  })(window.jQuery, window.TweenMax);
}).call(this);
