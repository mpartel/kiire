function setupPlaceMovementGui(positionUrlPattern) {
  
  function placePositionUrl(placeId) {
    return positionUrlPattern.replace(':place_id', placeId);
  }

  function idOfRow(placeRow) {
    return placeRow.id.split('-')[1];
  }

  function nameOfRow(placeRow) {
    return $.trim($(placeRow).find('td.name').text());
  }

  function makeSelect(thisId) {
    var html = '<select class="move-after">';
    html += '<option value=""></option>';

    var $placeRows = $('tr.place');
    var allIds = $.map($placeRows, function(row) { return idOfRow(row); })

    for (var i = -1; i < allIds.length; ++i) {
      var afterId;
      var afterName;
      var beforeId;
      var beforeName;
      if (i == -1) {
        afterId = 'top';
        afterName = '';
      } else {
        afterId = allIds[i];
        afterName = nameOfRow($placeRows[i]);
      }
      if (i + 1 < allIds.length) {
        beforeId = allIds[i + 1];
        beforeName = nameOfRow($placeRows[i + 1]);
      } else {
        beforeId = 'bottom';
        beforeName = '';
      }
      if (afterId != thisId && beforeId != thisId) {
        html +=
          '<option value="' + afterId + '">' +
            afterName + ' -> ... <- ' + beforeName +
          '</option>';
      }
    }
    html += '</select>';
    return $(html);
  }

  function updateSelects() {
    $('tr.place').each(function() {
      var thisId = idOfRow(this);
      var $row = $(this);
      $row.find('select.move-after').remove();

      var onChange = function() {
        var $select = $(this);
        var val = $select.val();

        var animate = function() {
          $row.fadeOut('slow', function() {
            if (val == 'top') {
              $('#places-manager > tbody').prepend($row);
            } else {
              $('#place-' + val).after($row);
            }

            updateSelects();

            $row.fadeIn('slow');
          });
        }

        if (val != '') {
          $.ajax({
            url: placePositionUrl(thisId),
            data: {below: val},
            dataType: 'text',
            type: 'PUT',
            success: function(data) {
              if (data == 'OK') {
                animate();
              }
            }
          });
        }
      };

      makeSelect(thisId).appendTo($row).change(onChange);
    });
  }

  updateSelects();

}
