document.addEventListener 'turbolinks:load', (event) ->
  if document.querySelector 'tbody'
    document.querySelector('tbody').addEventListener 'click', (event) ->
      # If clicking a checkbox that is not the 'select all' checkbox.
      if !(event.target.id == 'select_all') && event.target.name == 'guest_ids[]'
        # Uncheck the 'select all' checkbox.
        document.getElementById('select_all').checked = false

    document.getElementById('select_all').addEventListener 'click', (event) ->
      event.stopPropagation()

      allCheckBoxes = document.querySelectorAll(
        'input[type=checkbox][name="guest_ids[]"')
      uncheckedCheckBoxes = document.querySelectorAll(
        'input[type=checkbox][name="guest_ids[]"]:not(:checked)')

      # If no more checkboxes to check, click all checkboxes to uncheck them.
      if uncheckedCheckBoxes.length == 0
        allCheckBoxes.forEach (checkbox) ->
          checkbox.checked = false

      # Else if there are still checkboxes to check, check those.
      else
        uncheckedCheckBoxes.forEach (checkbox) ->
          checkbox.checked = true
