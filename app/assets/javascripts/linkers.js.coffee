$ ->
  $('#test-button').click (e) ->
    e.preventDefault()
    $('#test-results').show()
    readCSVFile()

  readCSVFile = ->
    csvContents = $('#CSVfile')[0].files[0]
    reader = new FileReader()

    reader.onload = (event) ->
      reader.result.split('\n').forEach (line) ->
        $tr = $('<tr>')
        $tr.append $('<td>' + line + '</td>')

        requestParams =
          url_string: line
          search_term: $('#search-term').val()

        $.getJSON('/ping_url', requestParams).done (result) ->
          result.forEach (item) -> $tr.append $('<td>' + item + '</td>')
          $('#test-results tbody').append $tr

    reader.readAsText(csvContents)
