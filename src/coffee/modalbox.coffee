class modalbox

  constructor: ->
    @htmloverflowy = $('html').css 'overflow-y'
    @num = $('div[class^="modal__box__"]').length + 1
    @dom_modal_box = ".modal__box__#{@num}"
    @dom_modal_content = ".modal__content"
    @dom_modal_overlay = ".modal__overlay"

  onClose: (e) =>
    #    $('html').css 'overflow-y', 'auto'
    #    $('body').css 'overflow-y', 'auto'
    @prefixedRemoveEventListener $(@dom_modal_box).find(@dom_modal_content), 'AnimationEnd', @onClose
    $(@dom_modal_box).remove()
    @options.onClose()
    return

  close: ->
    $length = @num-1
    if @options.hidebodyscroll && $length == 0
      $('html').css 'overflow-y', @htmloverflowy
      $('body').removeClass 'buuummodal_open'

    $(@dom_modal_box).find(@dom_modal_content).removeClass @options.show
    $(@dom_modal_box).find(@dom_modal_content).addClass @options.close

    $(@dom_modal_box).find(@dom_modal_overlay).removeClass 'show_buuummodal_opacity'
    $(@dom_modal_box).find(@dom_modal_overlay).addClass 'hide_buuummodal_opacity'


    @prefixedEventListener $(@dom_modal_box).find(@dom_modal_content), 'AnimationEnd', @onClose

    return

  setOptions: (options = {}) ->
    @div = false
    @clone = false
    @pfx = [
      'webkit'
      'moz',
      'MS'
      'o'
      ''
    ]

    # show classes
    # 'show_scale'
    # 'show_from_left'
    # 'show_from_right'
    # 'show_from_top'
    # 'show_from_bottom'

    # close classes
    # 'hide_scale'


    @options =
      ajax: false
      classload: false
      classcontainer: false
      htmlload: false
      closeoverlay: true
      width: false
      maxwidth: false
      minwidth: false
      fixheight: false
      overlaycolor: '#fff'
      hidebodyscroll: true
      position: "center"
      show: 'show_buuummodal_scale'
      close: 'hide_buuummodal_scale'
      onClose: ->
        return
      onLoad: ->
        return

    @options = @merge @options, options

    return

  # .modal__box
  #     .modal__overlay
  #     .modal__dialog
  #        @dom_modal_content  #             .modal__loading
  #                 .spinner.spinner-bounce-middle

  ini: ->
    box = "<div class='#{@dom_modal_box.substr(1)}' />"
    box = $(box)
    overlay = "<div class='#{@dom_modal_overlay.substr(1)}' />"
    overlay = $(overlay)
    overlay.css 'z-index', 1000 + @num
    overlay.css 'background-color', @options.overlaycolor
    # overlay.css 'opacity', 0
    dialog = $('<div class="modal__dialog" />')

    content = "<div class='#{@dom_modal_content.substr(1)}' />"
    content = $(content)
    content.css 'z-index', 1000 + @num + 1

    loading = $('<div class="modal__loading" />')
    loader = $('<div class="spinner spinner-bounce-middle" />')

    @iniEvents()

    if $(@dom_modal_box).length <= 0
      dialog.append content
      box.append overlay
      box.append dialog
      $('body').append box

    $(@dom_modal_box).find(@dom_modal_content).html ''
    $(@dom_modal_box).find(@dom_modal_overlay).removeClass 'hide_buuummodal_opacity'

    if @options.hidebodyscroll
      $('html').css 'overflow-y', 'hidden'
      $('body').addClass 'buuummodal_open'

    if @options.ajax
      loading.append loader
      $(@dom_modal_box).find(@dom_modal_content).append loading
      $(@dom_modal_box).find(@dom_modal_overlay).addClass 'show_buuummodal_opacity'
      @openmodal()
    else if @options.classload
      @clone = $(@options.classload).clone()
      @options.classcontainer = @options.classload
      # if $(@options.classload).css('display') == 'none'
      #     @clone.css 'display', 'block'
      # @div = @clone[0].outerHTML
      @div = @clone

      $(@dom_modal_box).find(@dom_modal_overlay).addClass 'show_buuummodal_opacity'

      ## add for wait for loading images
      @clone = $(@div).clone()
      @clone.css 'visibility', 'hidden'
      # remove script
      @clone.find('script').remove()
      $('body').append @clone

      @loaded_imgs = 0;
      @total_imgs = @clone.find('img').length;

      if @total_imgs > 0
        $.each @clone.find('img'), (i, el) =>
          $(el).one 'load', =>
            @imageLoaded()
            return
          return
      else
        @start_modal()
      ## end loading images
#      @start_modal()
    else
      @clone = $(@options.htmlload).clone()
      @options.classcontainer = @clone.attr('class')
      @div = @clone

      $(@dom_modal_box).find(@dom_modal_overlay).addClass 'show_buuummodal_opacity'
      @start_modal()

    return

  changeContent: (html, animation = false) ->
    $(@dom_modal_box).find(@dom_modal_content).html ''
    @clone = $(html).clone()
    @options.classcontainer = @clone.attr('class')
    @div = @clone
    @start_modal(animation)

  iniEvents: ->
    $(window).resize =>
      @resize()
      return

    $('body').one 'click', ".modal__box__close", (e) =>
      e.preventDefault()
      @close()
      return


    $('body').one 'click', "#{@dom_modal_box} #{@dom_modal_overlay}", (e) =>
      console.log @num
      e.preventDefault()
      @close() if @options.closeoverlay
      return

  content: (html) ->
    @div = $('<div />')
    @div.addClass @options.classcontainer
    @div.append html
    @start_modal()

  openmodal: ->
    @is_loading = true
    @resize()
    @is_loading = false
    if @options.ajax
      $.ajax(
        method: 'GET'
        url: @options.ajax
        dataType: "json"
      ).done (response) =>
        if response.error
          @div = $('<div class="modal_default"></div>')
          @div.html response.message
          @start_modal()
        else
          @div = $(response.html)

          @options.classcontainer = @div.attr('class')

          @clone = $(@div).clone()

          @clone.css 'visibility', 'hidden'
          @clone.find('script').remove()
          $('body').append @clone

          @loaded_imgs = 0;
          @total_imgs = @clone.find('img').length;

          if @total_imgs > 0
            $.each @clone.find('img'), (i, el) =>
              $(el).one 'load', =>
                @imageLoaded()
                return
              return
          else
            @start_modal()
        return
    else
      @resize()

    return

  start_modal: (animation = true) ->
    @clone.remove() if @clone

    $(@div).css 'display', 'block'

    $(@dom_modal_box).find(@dom_modal_content).html @div

    if animation
      @prefixedEventListener $(@dom_modal_box).find(@dom_modal_content), 'AnimationEnd', @onShow
      $(@dom_modal_box).find(@dom_modal_content).addClass @options.show

    @resize()

    @options.onLoad()

    return

  onShow: (e) =>
    $(@dom_modal_box).find(@dom_modal_content).removeClass @options.show
    @prefixedRemoveEventListener $(@dom_modal_box).find(@dom_modal_content), 'AnimationEnd', @onShow
    return

  imageLoaded: ->
    @loaded_imgs++;
    if @loaded_imgs == @total_imgs
      @start_modal()
    return

  resize: ->
    if $(@dom_modal_box).length > 0
      div = $(@dom_modal_box).find(@dom_modal_content)
      sizes = @realSizes div
      if sizes.height > sizes.window_h
        div.css 'top', 0
        vertical = "0"
        #        $('html').css 'overflow-y', 'hidden'
        #        $('body').css 'overflow-y', 'hidden'
      else
        if @options.position == 'top'
          div.css 'top', 0
          vertical = "0"
        else
          div.css 'top', (sizes.window_h / 2) - (sizes.height / 2) + "px"
          vertical = 0
      #        $('html').css 'overflow-y', 'auto'
      #        $('body').css 'overflow-y', 'auto'

      div.css('top', 0) if @options.fixheight && !@is_loading

      div.css 'left', 0
      if sizes.window_w > sizes.width
        div.css 'margin', "0 " + ((sizes.window_w / 2) - (sizes.width / 2)) + "px"

      $('.modal__dialog').css 'margin', "#{vertical} auto"
    return

  merge: (obj1 = {}, obj2 = {}) ->
    $.extend {}, obj1, obj2

  realSizes: (obj, objsize = false) ->
    width_ = window.innerWidth
    height_ = window.innerHeight
    width_body = $('body').innerWidth()
    height_body = $('body').innerHeight()

    pos = obj.css('position')
    if pos == 'absolute'
      obj.css 'position', 'relative'


    obj.css('width', @options.width) if @options.width
    obj.css('max-width', @options.maxwidth) if @options.maxwidth
    obj.css('min-width', @options.minwidth) if @options.minwidth

    children = obj.children()
    margintop = parseInt(children.first().css('margin-top'))
    marginbottom = parseInt(children.first().css('margin-bottom'))
    margins = marginbottom + margintop
    margintop = parseInt(children.first().css('padding-top'))
    marginbottom = parseInt(children.first().css('padding-bottom'))
    margins += marginbottom + margintop

    children.first().css('height', height_ - margins) if @options.fixheight && !@is_loading

    if objsize
      width = obj.find(objsize).outerWidth()
      height = obj.find(objsize).outerHeight()
    else if children.length > 1
      obj.css 'margin', 0
      width = obj.outerWidth()
      height = obj.outerHeight()
    else
      obj.css 'margin', 0
      width = children.outerWidth()
      height = children.outerHeight()

    if pos == 'absolute'
      obj.css 'position', pos

    {
      window_w: width_
      window_h: height_
      body_w: width_body
      body_h: height_body
      width: width
      height: height
    }

  prefixedEventListener: (element, type, callback) ->
    p = 0
    while p < @pfx.length
      if !@pfx[p]
        type = type.toLowerCase()
      if element[0]
        element[0].addEventListener @pfx[p] + type, callback, false
      p++
    return

  prefixedRemoveEventListener: (element, type, callback) ->
    p = 0
    while p < @pfx.length
      if !@pfx[p]
        type = type.toLowerCase()
      if element[0]
        element[0].removeEventListener @pfx[p] + type, callback, false
      p++
    return
