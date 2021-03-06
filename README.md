# README

### Created by:
- [Dominic Padula](https://github.com/domo2192) | [LinkedIn](https://www.linkedin.com/in/dominic-padula-5bb5b2179/)

#### Built With
* [Ruby on Rails](https://rubyonrails.org)
* [HTML](https://html.com)

This project was tested with:
* RSpec version 3.10
* [Postman](https://www.postman.com/) Explore and test the API endpoints using Postman, and use Postman’s CLI to execute collections directly from the command-line.

### About 

* This project is to demonstrate api consumption and creation when given the frontend wireframes.

### APIS Consumed
* Mapquest api https://developer.mapquest.com/ 
* Photo api https://www.pexels.com/api/ 
* For Weather Data https://openweathermap.org/api

#### Prerequisites

* __Ruby__

  - The project is built with rubyonrails using __ruby version 2.5.3p105__, you must install ruby on your local machine first. Please visit the [ruby](https://www.ruby-lang.org/en/documentation/installation/) home page to get set up. _Please ensure you install the version of ruby noted above._

* __Rails__
  ```sh
  gem install rails --version 5.2.5
  ```

* __Postgres database__
  - Visit the [postgresapp](https://postgresapp.com/downloads.html) homepage and follow their instructions to download the latest version of Postgres app.

#### Installing

1. Clone the repo
  ```
  $ git clone https://github.com/Yardsourcing/yardsourcing-frontend
  ```

2. Bundle Install
  ```
  $ bundle install
  ```

3. Create, migrate and seed rails database
  ```
  $ rails db:{create,migrate,seed}
  ```

4. Set up Environment Variables:
  - run `bundle exec figaro install`
  - add the below variable to the `config/application.yml` if you wish to use the existing email microservice. Otherwise you replace it the value with service if desired.

  If you do not wish to use the sample data provided to seed your database, replace the commands in `db/seeds.rb`.

### Endpoints
| HTTP verbs | Paths  |Required| Used for |Tips|
| ---------- | ------ | ------ |------| --------:|
| GET | /api/v1/forecast?location=denver,co |valid city passed in as location| Get the weather for a location ||
| GET | /api/v1/backgrounds?location=denver,co|valid location for area| Get a photo for a specific area||
| POST | /api/v1/users  | Valid email, password, and confirmation| Create a user account |Must pass required Json in body|
| Post| /api/v1/sessions  | valid email and password |Create a session get an api_key|Must pass required as Json in body|
| Post| /api/v1/road_trip |Must pass valid origin/desitnation/api_key| Creates a road trip |Must pass required as Json in body|

### How to Contribute

In the spirit of collaboration, things done together are better than done on our own. If you have any amazing ideas or contributions on how we can improve this API they are **greatly appreciated**. To contribute:

  1. Fork the Project
  2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
  3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
  4. Push to the Branch (`git push origin feature/AmazingFeature`)
  5. Open a Pull Request
