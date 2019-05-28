# List Comments :

This application is a tasks management sample app

## Brief :

- Used to create lists, assign it to members, add cards to it, comment and reply to cards 
- The app uses JWT for api authentication 

## Setting up the environment :

- Ruby version is `2.4.1`
- Database is Postgresql
- Rails version is `5.1.7`

## Usage :
- Navigate to the project folder from the terminal
  - Run 'bundle install'
  - Add your database configs to config/database.yml file to match your PostgreSQL server configurations
  - Run `bundle exec rake db:create` to create the database
  - Run `bundle exec rake db:schema:load` to load the current schema to your database
  - Run Rails local server using command `rails s`
  - From Api Rest client, create api calls using `http://localhost:3000` as a base url
