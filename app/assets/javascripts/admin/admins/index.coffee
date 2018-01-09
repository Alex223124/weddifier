document.addEventListener 'turbolinks:load', (event) ->
  document.querySelector('#select_all').addEventListener 'click', (event) ->
    document.querySelectorAll('input[type=checkbox][name="guest_ids[]"]').forEach (checkbox) ->
      checkbox.click()
