FROM ruby:2.6.5-alpine
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base ruby-dev postgresql-dev git bash
RUN mkdir /ingresse_development
WORKDIR /ingresse_development
COPY Gemfile /ingresse_development/Gemfile
COPY Gemfile.lock /ingresse_development/Gemfile.lock
RUN gem install bundler
RUN bundle install

# Remove build dependencies and install runtime dependencies
RUN apk add --update postgresql-client postgresql-libs tzdata
COPY . /ingresse_development
RUN touch /tmp/caching-dev.txt

# Add a script to be executed every time the container starts#.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
#EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
