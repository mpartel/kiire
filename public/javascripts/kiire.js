var Kiire = null;
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
    Kiire.selectPlace(self);
    return false;
  });
}

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
      self.element.select();
    }

    this.isEmpty = function() {
      return !this.element.value;
    }
  }

  Kiire = new function() {
    var self = this;

    this.from = new PlaceField('from');
    this.to = new PlaceField('to');
    this.via = $('input#via').length > 0 ? new PlaceField('via') : null;
    this.mobileReittiopasSetting = 'never';

    this.goButton = $('button#go');

    this.fields = [this.from, this.to];
    if (this.via) {
      this.fields.push(this.via);
    }

    this.from.nextField = this.to;
    if (this.via) {
      this.to.nextField = this.via;
      this.via.nextField = this.from;
    } else {
      this.to.nextField = this.from;
    }

    this.$allFieldElements = $($.map(this.fields, function(f) {return f.element}));

    this.fieldByElement = function(element) {
      for (var i = 0; i < self.fields.length; ++i) {
        if (self.fields[i].element == element) {
          return self.fields[i];
        }
      }
      return null;
    }

    this.programFocus = function() {
      function switchPlaceFieldFocus(field) {
        self.$allFieldElements.removeClass('focused-place-field');
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
      $.each(self.fields, function() {
        this.element.value = "";
      });
    }

    this.initialize = function() {
      this.programFocus();
      this.programEnter();
      this.programGoButton();
      this.clearForm(); // Some browsers store the form values on refresh. We don't want that.
      this.from.focus();
    }

    this.setMobileReittiopasSetting = function(setting) {
      this.mobileReittiopasSetting = setting;
    }

    this.shouldUseMobileVersion = function() {
      return (this.mobileReittiopasSetting == 'always');
    }

    this.selectPlace = function(place) {
      this.targetField.setValue(place.getAddressForBackend('reittiopas'));
      this.targetField.nextField.focus();
    }

    this.goNow = function() {

      var baseUrl;
      var params;

      if (!this.shouldUseMobileVersion()) {
        baseUrl = 'http://www.reittiopas.fi';
        params = {
          from_in: this.from.getValue(),
          to_in: this.to.getValue(),
          timetype: 'departure',
          nroutes: 5
        };
      } else {
        baseUrl = 'http://aikataulut.hsl.fi/reittiopas-pda/fi/';
        params = {
          keya: this.from.getValue(),
          keyb: this.to.getValue()
        };
      }

      if (this.via && this.via.getValue() != '') {
        params['searchformtype'] = 'advanced';
        params['via_in'] = this.via.getValue()
      }

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
