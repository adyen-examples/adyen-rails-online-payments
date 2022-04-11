FROM ruby:3.1.1

WORKDIR /app

COPY Gemfile ./

RUN ruby-install 3.1.1
RUN gem install bundle
RUN gem install rails
RUN bundle install

COPY . .

CMD [ "bundle", "exec", "rails", "s" ]

EXPOSE 3000
