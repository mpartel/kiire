var places = {};

function Place(id, name) {
  var self = this;

  this.id = id;
  this.name = name;

  places[id] = this;

  this.element = $('#place-' + id)[0];

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

    this.programFocus = function() {
      this.focuseableElements = [
        this.from.element,
        this.to.element,
        this.goButton
      ];

      $(this.from.element).focus(function() {
        self.focusedField = self.from;
      });
      $(this.to.element).focus(function() {
        self.focusedField = self.to;
      });

      this.from.focus();

      $('*').live('focus', function() {
        if ($.inArray(this, self.focuseableElements) > -1) {
          self.focusedField.focus();
        }
      });
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
      this.focusedField.setValue(place.name);
      this.focusedField.theOtherField.focus();
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

      $(this.goButton).attr('disabled', 'disabled');
      setTimeout(function() {
        $(this.goButton).attr('disabled', '');
      }, 2000);

      window.location.href = url;
    }

    this.initialize();
  }
});
