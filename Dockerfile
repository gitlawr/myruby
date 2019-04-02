FROM ruby:2.5.1-alpine

# Edit with nodejs, mysql-client, postgresql-client, sqlite3, etc. for your needs.
# Or delete entirely if not needed.
RUN apk --no-cache add nodejs postgresql-client tzdata

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock /usr/src/app/
# Install build dependencies - required for gems with native dependencies
RUN apk add --no-cache --virtual build-deps build-base postgresql-dev && \
  bundle install && \
  apk del build-deps

COPY . /usr/src/app

# For Rails
ENV PORT 5000
EXPOSE $PORT
CMD ["sh", "-c", "bundle exec rails server -p ${PORT}"]
