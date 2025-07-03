FROM ruby:3.3.6-slim

WORKDIR /runner

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential && \
  rm -rf /var/lib/apt/lists

COPY runner.rb .

CMD ["ruby", "runner.rb"]