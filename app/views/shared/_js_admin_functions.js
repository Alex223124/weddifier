'use strict';

function currentDate() {
  var dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  var monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  var today = new Date();
  var dayName = dayNames[today.getDay()];
  var dayNumber = today.getDate();
  var month = monthNames[today.getMonth()];
  var time = today.toLocaleString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true }).replace('PM', 'pm').replace(' ', '');

  return dayName + ' ' + dayNumber + ' ' + month + ' ' + time;
}

function setCurrentDateFor(guestID) {
  var row = document.querySelector('' +
    'input[name="guest_ids[]"][value="' + guestID + '"]').parentNode.parentNode;
  row.lastElementChild.innerHTML = currentDate();
}

function updateInvitedCounter(newInvitesCount) {
  var oldTotaInvitedCount = Number(document.getElementById('all-invited-guests-counter').innerHTML);
  var newTotalInvitedCount = oldTotaInvitedCount + newInvitesCount;

  document.getElementById('all-invited-guests-counter').innerHTML = newTotalInvitedCount;
}

function updateRemainingCounter(newInvitesCount) {
  var oldRemainingCount = Number(document.getElementById('all-remaining-guests-counter').innerHTML);
  var newRemainingCount = oldRemainingCount - newInvitesCount;

  document.getElementById('all-remaining-guests-counter').innerHTML = newRemainingCount;
}

function uncheckCheckboxes() {
  document.querySelectorAll('input[type="checkbox"').forEach(function (input) {
    input.checked = false;
  });
}

function disableInviteButtonFor(guestID) {
  var inviteRowButton = document.querySelector('a[href="/guests/' + guestID + '/invitations"]');
  inviteRowButton.classList.remove('btn-success');
  inviteRowButton.classList.add('btn-outline-success', 'btn-disabled', 'btn-outline-success.disabled');
  inviteRowButton.parentNode.innerHTML = "" +
    '<form class="button_to" method="post" action="/admin" data-remote="true">' +
      '<input disabled="disabled" class="btn btn-outline-success" type="submit" value="Invited">' +
    "</form>";
}

function disableRemoveButtonFor(guestID) {
  var removeRowButton = document.querySelector('a[href="/guests/' + guestID + '"]');
  removeRowButton.remove();
}