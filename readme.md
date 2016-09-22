ModalBox - Simple modal box
===========================

## Install

### Bower

Buuum is available on Bower and can be installed using:

```
bower install buuummodal
```

### Options

```
options = {
  ajax: false,
  classload: false,
  classcontainer: false,
  htmlload: false,
  closeoverlay: true,
  overlaycolor: '#fff',
  show: 'show_scale',
  width: false, // percent
  maxwidth: false, // percent
  minwidth: false, // percent
  fixheight: false,
  close: 'hide_scale',
  onclose: function() {}
}
```

## show functions

* show_scale
* show_from_left
* show_from_right
* show_from_top
* show_from_bottom

## close functions

* hide_opacity
* hide_scale
* hide_top

## Events
### When modal close fire this event
* onClose()

## Examples

```
modal = new modalbox();
modal.setOptions({
    classload: '.demomodal'
});
modal.ini();
```

```
modal = new modalbox();
modal.setOptions({
    htmlload: '<h1>Welcome modal</h1>'
});
modal.ini();
```

## Ajax
* Ajax response must be this format

```
{
  "error": false,
  "message": "error message",
  "html": "<h1>html to load in modal</h1>"
}
```

```
modal = new modalbox();
modal.setOptions({
    ajax: '//example.com/path/to/file'
    width: '50%',
    fixheight: true
});
modal.ini();
```
