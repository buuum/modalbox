ModalBox - Simple modal box
===========================

## Install

### Bower

Buuum is available on Bower and can be installed using:

```
bower install buuummodal#v2
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
  show: 'show_buuummodal_scale',
  width: false, // percent
  maxwidth: false, // percent
  minwidth: false, // percent
  fixheight: false,
  hidebodyscroll: true,
  position: 'top', // default: 'center'
  close: 'hide_buuummodal_scale',
  onclose: function() {}
}
```

## show functions

* show_buuummodal_scale
* show_buuummodal_from_left
* show_buuummodal_from_right
* show_buuummodal_from_top
* show_buuummodal_from_bottom

## close functions

* hide_buuummodal_opacity
* hide_buuummodal_scale
* hide_buuummodal_top

## Methods
### Change content modal
```js
animation = false;
modal.changeContent(html, animation);
```

## Events
### When modal close fire this event
* onClose()
* onLoad()

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
