**Weddifier** is a concept app developed for a friend who's getting married, aimed at allowing the couple to gather missing information about their guests, quickly send email invite, dismiss (remove), confirm and take notes about them if needed.

It is intended to be a single-page stop for wedding guests to leave out their data, not a complete website full of the wedding info, so the actual app is rather the admin panel side of it.

## Features

### Administration panel

* Paginated.
* Sorts/Filters.
* Search by all guest data.
* AJAXified single guest quick invite and removal.
* AJAXified bulk invite.
* Guests receive email and confirm via link, so bride can see who's confirmed/pending.
* Add notes about a particular guest.
* Color a guest depending on a manual status added by the couple. E.g. (Call/Confirmed/Declined).

### Front page

 * Responsive front-page for guests to quickly register sparkled with little details to provide a pleasant user experience.

## General

* Unit/Integration tests with RSpec and Capybara.
* Used Bootstrap 4 to aid in rapid concept development.
* CircleCI staging/production cycle.

## Roadmap

* Convert it to a multi-tenant app for people to create their own wedding register, with images and styles of their choosing.

## Demo

http://weddifier.herokuapp.com
Admin: /admin
admin@example.com
test
