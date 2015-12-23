$ ->
  $('#test-button').click (e) ->
    e.preventDefault()
    $('#test-results').show()
    $('#test-results tbody tr').remove()
    readCSVFile()

  readCSVFile = ->
    csvContents = $('#CSVfile')[0].files[0]
    reader = new FileReader()

    reader.onload = (event) ->
      reader.result.split('\n').forEach (line) ->
        if line is ''
          return
        $tr = $('<tr>')
        $tr.append $('<td>' + line + '</td>')

        requestParams =
          url_string: line
          search_term: $('#search-term').val()
          include_dynamic_tags: $('#include_dynamic_tags').is(":checked")

        $.getJSON('/ping_url', requestParams).done (result) ->
          result.forEach (item) -> $tr.append $('<td>' + item + '</td>')
          $('#test-results tbody').append $tr

    reader.readAsText(csvContents)
