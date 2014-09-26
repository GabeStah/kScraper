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
    order: [[3, "desc" ]]
    pagingType: 'full_numbers'
    processing: true
    serverSide: true

  # Refresh data
  setInterval ->
    table.ajax.reload(null, false)
  , 30000

  # Hide row temporarily when Ignored clicked
  $('#posts-table tbody').on(
    'click'
    'a[id*=ignored_link_]'
    -> $(this).parent().parent().hide()
  )

  # Points tooltips
  $('#posts-table').on 'draw.dt', ->
    $(".post-link").each ->
      $(this).tipsy({gravity: 'nw', html: true, title: 'data-tip', css: { 'width': '500px' }}) unless $(this).data('tip') == undefined
    $(".response-link").each ->
      $(this).tipsy({gravity: 'ne', html: true, title: 'data-tip', css: { 'width': '500px' }}) unless $(this).data('tip') == undefined


#  $('#posts-table tbody tr').each ->
#    $('td:nth-of-type(3)').addClass('special')

#jQuery ->
#  $('td').hover -> alert($(this).attr 'id')