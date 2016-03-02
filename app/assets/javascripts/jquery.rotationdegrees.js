(function ($) {
    $.fn.rotationDegrees = function () {
      var matrix = this.css("-webkit-transform") ||
        this.css("-moz-transform")    ||
        this.css("-ms-transform")     ||
        this.css("-o-transform")      ||
        this.css("transform");
      if(typeof matrix === 'string' && matrix !== 'none') {
          var values = matrix.split('(')[1].split(')')[0].split(',');
          var a = values[0];
          var b = values[1];
          var angle = Math.round(Math.atan2(b, a) * (180/Math.PI));
      } else { var angle = 0; }
      return angle;
   };
}(jQuery));
