var modalbox,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

modalbox = (function() {
  function modalbox() {
    this.onShow = bind(this.onShow, this);
    this.onClose = bind(this.onClose, this);
    $(window).resize((function(_this) {
      return function() {
        _this.resize();
      };
    })(this));
    $('body').on('click', ".modal__box__close", (function(_this) {
      return function(e) {
        e.preventDefault();
        _this.close();
      };
    })(this));
    $('body').on('click', ".modal__overlay", (function(_this) {
      return function(e) {
        e.preventDefault();
        if (_this.options.closeoverlay) {
          _this.close();
        }
      };
    })(this));
  }

  modalbox.prototype.onClose = function(e) {
    this.prefixedRemoveEventListener($('.modal__content'), 'AnimationEnd', this.onClose);
    $('.modal__box').remove();
    this.options.onclose();
  };

  modalbox.prototype.close = function() {
    if (this.options.hidebodyscroll) {
      $('body').removeClass('buuummodal_open');
    }
    $('.modal__content').removeClass(this.options.show);
    $('.modal__content').addClass(this.options.close);
    $('.modal__box').find('.modal__overlay').removeClass('show_buuummodal_opacity');
    $('.modal__box').find('.modal__overlay').addClass('hide_buuummodal_opacity');
    this.prefixedEventListener($('.modal__content'), 'AnimationEnd', this.onClose);
  };

  modalbox.prototype.setOptions = function(options) {
    if (options == null) {
      options = {};
    }
    this.div = false;
    this.clone = false;
    this.pfx = ['webkit', 'moz', 'MS', 'o', ''];
    this.options = {
      ajax: false,
      classload: false,
      classcontainer: false,
      htmlload: false,
      closeoverlay: true,
      width: false,
      maxwidth: false,
      minwidth: false,
      fixheight: false,
      overlaycolor: '#fff',
      hidebodyscroll: true,
      show: 'show_buuummodal_scale',
      close: 'hide_buuummodal_scale',
      onclose: function() {}
    };
    this.options = this.merge(this.options, options);
  };

  modalbox.prototype.ini = function() {
    var box, content, dialog, loader, loading, overlay;
    box = $('<div class="modal__box" />');
    overlay = $('<div class="modal__overlay" />');
    overlay.css('background-color', this.options.overlaycolor);
    dialog = $('<div class="modal__dialog" />');
    content = $('<div class="modal__content" />');
    loading = $('<div class="modal__loading" />');
    loader = $('<div class="spinner spinner-bounce-middle" />');
    if ($('.modal__box').length <= 0) {
      dialog.append(content);
      box.append(overlay);
      box.append(dialog);
      $('body').append(box);
    }
    $('.modal__content').html('');
    $('.modal__box').find('.modal__overlay').removeClass('hide_buuummodal_opacity');
    if (this.options.hidebodyscroll) {
      $('body').addClass('buuummodal_open');
    }
    if (this.options.ajax) {
      loading.append(loader);
      $('.modal__content').append(loading);
      $('.modal__box').find('.modal__overlay').addClass('show_buuummodal_opacity');
      this.openmodal();
    } else if (this.options.classload) {
      this.clone = $(this.options.classload).clone();
      this.options.classcontainer = this.options.classload;
      this.div = this.clone;
      $('.modal__box').find('.modal__overlay').addClass('show_buuummodal_opacity');
      this.start_modal();
    } else {
      this.clone = $(this.options.htmlload).clone();
      this.options.classcontainer = this.clone.attr('class');
      this.div = this.clone;
      $('.modal__box').find('.modal__overlay').addClass('show_buuummodal_opacity');
      this.start_modal();
    }
  };

  modalbox.prototype.content = function(html) {
    this.div = $('<div />');
    this.div.addClass(this.options.classcontainer);
    this.div.append(html);
    return this.start_modal();
  };

  modalbox.prototype.openmodal = function() {
    this.is_loading = true;
    this.resize();
    this.is_loading = false;
    if (this.options.ajax) {
      Api.getData({
        url: this.options.ajax
      }, (function(_this) {
        return function(response, error) {
          if (!error) {
            if (response.error) {
              _this.div = $('<div class="modal_default"></div>');
              _this.div.html(response.message);
              _this.start_modal();
            } else {
              _this.div = $(response.html);
              _this.options.classcontainer = _this.div.attr('class');
              _this.clone = $(_this.div).clone();
              _this.clone.css('visibility', 'hidden');
              $('body').append(_this.clone);
              _this.loaded_imgs = 0;
              _this.total_imgs = _this.clone.find('img').length;
              if (_this.total_imgs > 0) {
                $.each(_this.clone.find('img'), function(i, el) {
                  $(el).one('load', function() {
                    _this.imageLoaded();
                  });
                });
              } else {
                _this.start_modal();
              }
            }
          }
        };
      })(this));
    } else {
      this.resize();
    }
  };

  modalbox.prototype.start_modal = function() {
    if (this.clone) {
      this.clone.remove();
    }
    $(this.div).css('display', 'block');
    $('.modal__content').html(this.div);
    this.prefixedEventListener($('.modal__content'), 'AnimationEnd', this.onShow);
    $('.modal__content').addClass(this.options.show);
    this.resize();
  };

  modalbox.prototype.onShow = function(e) {
    $('.modal__content').removeClass(this.options.show);
    this.prefixedRemoveEventListener($('.modal__content'), 'AnimationEnd', this.onShow);
  };

  modalbox.prototype.imageLoaded = function() {
    this.loaded_imgs++;
    if (this.loaded_imgs === this.total_imgs) {
      this.start_modal();
    }
  };

  modalbox.prototype.resize = function() {
    var div, sizes, vertical;
    if ($('.modal__box').length > 0) {
      div = $('.modal__content');
      sizes = this.realSizes(div);
      if (sizes.height > sizes.window_h) {
        div.css('top', 0);
        vertical = "0";
      } else {
        div.css('top', (sizes.window_h / 2) - (sizes.height / 2) + "px");
        vertical = 0;
      }
      if (this.options.fixheight && !this.is_loading) {
        div.css('top', 0);
      }
      div.css('left', 0);
      if (sizes.window_w > sizes.width) {
        div.css('margin', "0 " + ((sizes.window_w / 2) - (sizes.width / 2)) + "px");
      }
      $('.modal__dialog').css('margin', vertical + " auto");
    }
  };

  modalbox.prototype.merge = function(obj1, obj2) {
    if (obj1 == null) {
      obj1 = {};
    }
    if (obj2 == null) {
      obj2 = {};
    }
    return $.extend({}, obj1, obj2);
  };

  modalbox.prototype.realSizes = function(obj, objsize) {
    var children, height, height_, height_body, marginbottom, margins, margintop, pos, width, width_, width_body;
    if (objsize == null) {
      objsize = false;
    }
    width_ = window.innerWidth;
    height_ = window.innerHeight;
    width_body = $('body').innerWidth();
    height_body = $('body').innerHeight();
    pos = obj.css('position');
    if (pos === 'absolute') {
      obj.css('position', 'relative');
    }
    if (this.options.width) {
      obj.css('width', this.options.width);
    }
    if (this.options.maxwidth) {
      obj.css('max-width', this.options.maxwidth);
    }
    if (this.options.minwidth) {
      obj.css('min-width', this.options.minwidth);
    }
    children = obj.children();
    margintop = parseInt(children.first().css('margin-top'));
    marginbottom = parseInt(children.first().css('margin-bottom'));
    margins = marginbottom + margintop;
    margintop = parseInt(children.first().css('padding-top'));
    marginbottom = parseInt(children.first().css('padding-bottom'));
    margins += marginbottom + margintop;
    if (this.options.fixheight && !this.is_loading) {
      children.first().css('height', height_ - margins);
    }
    if (objsize) {
      width = obj.find(objsize).outerWidth();
      height = obj.find(objsize).outerHeight();
    } else if (children.length > 1) {
      obj.css('margin', 0);
      width = obj.outerWidth();
      height = obj.outerHeight();
    } else {
      obj.css('margin', 0);
      width = children.outerWidth();
      height = children.outerHeight();
    }
    if (pos === 'absolute') {
      obj.css('position', pos);
    }
    return {
      window_w: width_,
      window_h: height_,
      body_w: width_body,
      body_h: height_body,
      width: width,
      height: height
    };
  };

  modalbox.prototype.prefixedEventListener = function(element, type, callback) {
    var p;
    p = 0;
    while (p < this.pfx.length) {
      if (!this.pfx[p]) {
        type = type.toLowerCase();
      }
      element[0].addEventListener(this.pfx[p] + type, callback, false);
      p++;
    }
  };

  modalbox.prototype.prefixedRemoveEventListener = function(element, type, callback) {
    var p;
    p = 0;
    while (p < this.pfx.length) {
      if (!this.pfx[p]) {
        type = type.toLowerCase();
      }
      if (element[0]) {
        element[0].removeEventListener(this.pfx[p] + type, callback, false);
      }
      p++;
    }
  };

  return modalbox;

})();
