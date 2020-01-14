# Ingresse Developer Test

This repository contains an application design for the requested project in the Ingresse Backend Developer Test, better described in [this gist](https://gist.github.com/vitorleal/158e4e3870337dacf9475a5a27e5c7c9).

## Introduction

The application was developed using Ruby as the programming language, and Rails as the main development framework. As requested, the REST API was fully created, and it has an extensible test coverage, with both unit and integration tests.

Regarding its infrastructure, the application runs entirelly into Docker containers, with PostgreSQL as its database, and a cache layer using Redis. Two environment were set up: development and production. *On production, Nginx is used as a proxy service, as requested*.

Besides that, on pushing, merging and pulling-request to the master branch, a Continuos Integration workflow was set up, allowing developers to properly detect any problem on building or testing the application.

Furthermore, it is possible to check the API's functionality on a heroku app - you can find how to properly access it and make requests to it below.

## Setup

The only things you need to have installed in your machine to set up the project are `docker` and `docker-compose`.

With that properly installed, you are done to start configuring the application on your local machine, by forking this repository, and cloning it whatever you want.

Once you get all the files, you have to simply run a couple of docker commands inside the application's directory.

```
# docker-compose build
# docker-compose up production
# docker-compose db:prepare
```

That's all!

The above commands will build the application and its containers on both environments, then it will run it on production and prepare the database to be used. After everything is done the application will be running on port 80, which you will be able to verify by testing the API with the instructions below.

**OBS:** To run the development environment, change `docker-compose up production` to `docker-compose up development`. It will run the application on port 3001.

## Testing the API locally

With your favorite REST Client, it is possible to make GET, POST, PATCH and DELETE requests to the API as you want.

- GET: http://127.0.0.1/users (list all users);
- GET: http://127.0.0.1/users/:id (list a single user, based on its ID);
- POST: http://127.0.0.1/users (creates a new user);
- PATCH: http://127.0.0.1/users/:id (updates some attributes of a single user, based on its ID);
- DELETE: http://127.0.0.1/users/:id (destroy a single user, based on its ID);

Below there is an example of a valid user object which can be used on a POST request:

```json
{
  "user": {
    "name": "Linus Torvald",
    "email": "linus@torvald.com",
    "password": "linus123"
  }
}
```

## Testing the API on Heroku

As I have mentioned above, I have deployed the application on Heroku for simples tests on the API. To run it there, just change the URI requests above (127.0.0.1) to **guarded-scrubland-77768.herokuapp.com**. It should work the same as locally.

## Continuos Integration

The application has a Continuos Integration workflow, and you can check it by simply pushing any modification to the master branch of your forked repository.

Once you push it to Github, you will be able to check the status of the building process on Github Actions. On your browser, go to your repository and click on "Actions" at the top menu. You will see a dashboard with all workflows. Select the correct one, and behold the magic happening.

## Considerations

To verify the cache layer implementation, you can make any GET request available to the API and check the logs to verify that no call is made to the database after the second straight request to the same endpoint *(just be careful though, because there is a rule to clear Redis cache keys after create and update methods)*.

**OBS:** On production environment, run `tail -f log/production.rb` to check the logs in real time. On development, simply change it to `development.rb`.
