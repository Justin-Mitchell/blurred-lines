###
blurredLines jQuery Plugin v0.0.4 - Blur background images with ease
Release: 19/09/2013
Author: Jeremy Woertink
 
http://github.com/tabeso/blurredLines
 
Licensed under the WTFPL license: http://www.wtfpl.net/txt/copying/
###
(($, window, document) ->
  $this = undefined
 
  # Plugin Settings
  _settings =
    blur: 10
    opacity: 0.8
  
  # Check support for the CSS
  _tmp_el = document.createElement('div').style
  _webkit = '-webkit-filter' of _tmp_el
  _firefox = '-moz-filter' of _tmp_el
  _opera = '-o-filter' of _tmp_el
  _msie = '-ms-filter' of _tmp_el
  _svgSupport = document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Shape", "1.0")
  _oldie = navigator.userAgent.match(/msie/ig) != null
  
  methods =
    init: (options) ->
      $this = $(@)
      $.extend _settings, (options or {})
      $this.each (index, el) ->
        $elem = $(el)
        $elem.css('opacity', _settings.opacity)
        if _webkit
          $elem.css('-webkit-filter', "blur(#{_settings.blur}px)")
        else if _firefox
          $elem.css('-moz-filter', "blur(#{_settings.blur}px)")
        else if _opera
          $elem.css('-o-filter', "blur(#{_settings.blur}px)")
        else if _msie
          $elem.css('-ms-filter', "blur(#{_settings.blur}px)")
        else if _oldie
          $elem.css('filter', "progid:DXImageTransform.Microsoft.Blur(PixelRadius='#{_settings.blur}')")
        else if _svgSupport
          $svg = _internals.generateSVG(index)
          $elem.append($svg)
          if $elem.prop('id') == ''
            $elem.prop('id', "xBlurredContainer#{index}")
          id = $elem.prop('id')
          $blurBox = $("<div id='xBlurredMask#{index}'></div>")
          $blurBox.css
            background: "-moz-element(##{id}) no-repeat scroll 0 0 transparent"
            filter: "url(#f#{index})"
            width: "100%"
            height: "100%"
            top: "0"
            position: "absolute"
          $elem.append($blurBox)
        else
          _internals.log('No clue how to blur for your browser :(')
      return $this
    
    # Unblur the object
    destroy: ->
      # TODO: implement
      return $this
  _internals =
    generateSVG: (num)->
      $svg = $('<svg xmlns="http://www.w3.org/2000/svg" version="1.1"><defs><filter id="f'+num+'" x="0" y="0"><feGaussianBlur in="SourceGraphic" stdDeviation="'+(parseInt(_settings.blur, 10) - 5)+'" /></filter></defs></svg>')
      $svg.find('svg').css('height', '0')
      $svg
    log: (msg)->
      if 'console' of window
        console.log msg
  # Setup plugin
  $.fn.blurredLines = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist on jquery.blurredLines"
) jQuery, window, document