FROM ruby:2.5.1

RUN apt-get update
RUN apt-get install -y postgresql-client

WORKDIR /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
