var places = {};

function Place(attribs) {
  var self = this;

  this.id = attribs['id'];
  this.name = attribs['name'];
  this.settings = attribs['settings']

  places[this.id] = this;

  this.getAddressForBackend = function(backend) {
    backend = self.settings[backend];
    if (backend && backend['address_for']) {
      return backend['address_for'];
    } else {
      return self.name;
    }
  }

  this.element = $('#place-' + this.id)[0];

  $(this.element).click(function() {
    UI.selectPlace(self);
    return false;
  });
}

UI = null;

$(document).ready(function() {

  function PlaceField(id) {
    var self = this;

    this.id = id;
    this.element = $('input#' + id)[0];
    this.container = $('#' + id + '-container');

    this.setValue = function(newValue) {
      self.element.value = newValue;
    }

    this.getValue = function() {
      return self.element.value;
    }

    this.focus = function() {
      self.element.focus();
    }

    this.isEmpty = function() {
      return !this.element.value;
    }
  }

  UI = new function() {
    var self = this;

    this.from = new PlaceField('from');
    this.to = new PlaceField('to');

    this.goButton = $('button#go');

    this.from.theOtherField = this.to;
    this.to.theOtherField = this.from;

    this.fieldByElement = function(element) {
      if (element == self.from.element) {
        return self.from;
      } else if (element == self.to.element) {
        return self.to;
      } else {
        return null;
      }
    }

    this.programFocus = function() {
      function switchPlaceFieldFocus(field) {
        $(field.theOtherField.element).removeClass('focused-place-field');
        self.targetField = field;
        $(field.element).addClass('focused-place-field');
        return true;
      }

      $('*').live('focus', function() {
        var field = self.fieldByElement(this);
        if (field) {
          switchPlaceFieldFocus(field);
        }
      });

      this.from.focus();
    }

    this.programEnter = function() {
      $('input.place').keydown(function(e) {
        if (e.keyCode == 13) {
          self.goNow();
        }
        return true;
      });
    }

    this.programGoButton = function() {
      $(this.goButton).click(function() {
        self.goNow();
      });
    }

    this.clearForm = function() {
      this.from.element.value = "";
      this.to.element.value = "";
    }

    this.initialize = function() {
      this.programFocus();
      this.programEnter();
      this.programGoButton();
      this.clearForm(); // Some browsers store the form values on refresh. We don't want that.
      this.from.focus();
    }


    this.selectPlace = function(place) {
      this.targetField.setValue(place.getAddressForBackend('reittiopas'));
      this.targetField.theOtherField.focus();
    }

    this.goNow = function() {
      var baseUrl = 'http://www.reittiopas.fi';
      var params = {
        from_in: this.from.getValue(),
        to_in: this.to.getValue(),
        timetype: 'departure',
        nroutes: 5
      };

      var queryString = [];
      $.each(params, function(key, value) {
        queryString.push(key + '=' + encodeURIComponent(value));
      });

      var url = baseUrl + '?' + queryString.join('&');

      window.location.href = url;
    }

    this.initialize();
  }
});
