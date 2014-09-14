# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# INDEX
jQuery ->
  $('#posts-table').dataTable
    ajax: $('#posts-table').data('source')
    lengthMenu: [ [10, 25, 50, 2147483646], [10, 25, 50, "All"] ]
    order: [[3, "desc" ]]
    pagingType: 'full_numbers'
    processing: true
    serverSide: true