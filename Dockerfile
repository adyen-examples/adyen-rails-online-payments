FROM ruby:3.1.1

WORKDIR /app

COPY Gemfile ./

RUN bundle install

COPY . .

CMD [ "bundle", "exec", "rails", "s" ]
