FROM ruby:3.1.1

WORKDIR /app

COPY . /app

RUN gem install bundle
RUN bundle install

COPY . .

CMD [ "bundle", "exec", "rails", "s" ]

EXPOSE 3000
