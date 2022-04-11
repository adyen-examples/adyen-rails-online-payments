FROM ruby:3.1.1

WORKDIR /app
COPY . /app

RUN gem install bundler
RUN gem install mini_racer
RUN bundle install

COPY . .

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

EXPOSE 3000
