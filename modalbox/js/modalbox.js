$.fn.modalbox = function() {
  var ini;
  this.each(function(i) {
    return console.log(i);
  });
  return ini = function(i) {
    var box, content, dialog, loader, loading, overlay;
    box = $('<div class="modal__box" />');
    overlay = $('<div class="modal__overlay" />');
    dialog = $('<div class="modal__dialog" />');
    content = $('<div class="modal__content" />');
    loading = $('<div class="modal__loading" />');
    loader = $('<div class="spinner spinner-bounce-middle" />');
    return console.log('demo');
  };
};
