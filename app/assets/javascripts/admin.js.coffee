window.Admin = 
  sort: (element) ->
    if typeof element is "number"
      column = element
    else
      column = $(element.parentNode.childNodes).toArray().indexOf(element)
    return false if column < 0
    if window.last_sorted_by >= 0 and window.last_sorted_by == column
      reverse = true
      window.last_sorted_by = 'reverse'
    else
      reverse = false
      window.last_sorted_by = column
    sortNumber = (a, b) ->
      parseInt(a) - parseInt(b)
    getValue = (element)->
      value = $(element.childNodes).eq(column).text()
      if value == "" then return null else value
    sort_methods = [ sortNumber, null, null, null, null, null, null, false, false ]
    false if sort_methods[column] is false 
    elements = $("tr").toArray()
    header = elements.splice(0, 1)
    values = []
    sorted = []
    ghost_table = []
    for element in elements
      values.push getValue element
    $("tbody").html ""
    $("table").append header
    sorted = values.slice().sort(sort_methods[column])
    sorted = sorted.reverse() if reverse
    new_elements = []
    for value in sorted
      $('table').append elements[values.indexOf(value)]
      delete values[values.indexOf(value)]

  filter: (query)->
    rows = $('tr')
    results = []
    window.shadow_rows = rows if not window.shadow_rows
    header = rows.splice(0, 1)
    for row in rows
      regex = RegExp(query,"i")
      if not not $(row).find('td').text().match regex
        results.push row
    $('table').html('')
    $('table').append header
    if results and results.length > 0 and query and query != ''
      for element in results
        $('table').addClass('filtering')
        $('table').append element
    else
      for element in window.shadow_rows
        $('table').removeClass('filtering')
        $('table').append element


$(".admin table").delegate "th", "click", ->
  window.Admin.sort this