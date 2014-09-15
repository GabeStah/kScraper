# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# INDEX
jQuery ->
  table = $('#posts-table').DataTable
    #ajax: $('#posts-table').data('source')
    ajax: '/posts.json'
    columnDefs: [{
      width: '32px'
      targets: 0
      sorting: false
    }]
    lengthMenu: [ [25, 50, 100, 2147483646], [25, 50, 100, "All"] ]
    order: [[2, "desc" ]]
    pagingType: 'full_numbers'
    processing: true
    serverSide: true

  # Refresh data
  setInterval ->
    table.ajax.reload(null, false)
  , 10000

  # Hide row temporarily when Ignored clicked
  $('#posts-table tbody').on(
    'click'
    'a[id*=ignored_link_]'
    -> $(this).parent().parent().hide()
  )

#jQuery ->
#  $('td').hover -> alert($(this).attr 'id')