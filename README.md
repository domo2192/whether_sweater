# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


### Endpoints
| HTTP verbs | Paths  |Required| Used for |Tips|
| ---------- | ------ | ------ |------| --------:|
| GET | /api/v1/forecast?location=denver,co |valid city passed in as location| Get the weather for a location |
| GET | /api/v1/backgrounds?location=denver,co|valid location for area| Get a photo for a specific area|
| POST | /api/v1/users  | Valid email, password, and confirmation| Create a user account ||Must Pass required Json in body|
| Post| /api/v1/sessions  | valid email and password |Create a session get an api_key|Must Pass required as Json in body|
| Post| /api/v1/road_trip |Must pass valid origin/desitnation/api_key| Creates a road trip |Must required as Json in body|
