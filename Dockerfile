FROM ruby:3.1.1

WORKDIR /app

RUN bundle install

COPY . .

CMD [ "rails", "s" ]
