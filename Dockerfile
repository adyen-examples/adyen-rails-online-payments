FROM ruby:3.1.1

WORKDIR /app
COPY . /app

RUN gem install bundler
RUN gem install mini_racer
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s"]