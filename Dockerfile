FROM ruby:3.0.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install yarn
WORKDIR /myapp
COPY ./ /myapp
RUN gem install bundler
# Run bundle config set --local without 'development test'
RUN bundle install
# RUN bundle exec rails db:create
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]