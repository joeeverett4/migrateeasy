FROM ruby:3.1

ARG SHOPIFY_API_KEY
ENV SHOPIFY_API_KEY=$SHOPIFY_API_KEY

RUN apt-get update && apt-get install -y nodejs npm git build-essential libpq-dev libsqlite3-dev bash openssl
WORKDIR /app

COPY web .

RUN gem install sqlite3 -v '1.6.9' --source 'https://rubygems.org/'

RUN cd frontend && npm install
RUN bundle install

RUN cd frontend && npm run build
RUN bundle exec rake build:all

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD rails server -b 0.0.0.0 -e production
