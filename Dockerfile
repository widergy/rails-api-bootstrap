# syntax=docker/dockerfile:1.10

# === Stage 1: Build Stage ===
FROM ruby:3.3.9-slim AS builder

ARG RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libyaml-dev \
  git

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN BUNDLER_VERSION=$(tail -n 1 Gemfile.lock | tr -d '[:space:]') \
    && gem install bundler --version "$BUNDLER_VERSION" --no-document

RUN --mount=type=secret,id=ca_token,env=CA_TOKEN \
    if [ -n "$CA_TOKEN" ]; then \
      export BUNDLE_WIDERGYDEV___325736894961__D__CODEARTIFACT__US___EAST___1__AMAZONAWS__COM="aws:${CA_TOKEN}"; \
    fi; \
    if [ "$RAILS_ENV" = "development" ] || [ "$RAILS_ENV" = "test" ]; then \
      bundle install; \
    else \
      bundle config set --local without 'development test' && bundle install; \
    fi

COPY . .

ENV SECRET_KEY_BASE=dummyKey

RUN bundle exec rake assets:precompile

# === Stage 2: Production Stage ===
FROM ruby:3.3.9-slim

RUN apt-get update -qq && apt-get install -y \
  libpq5 \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates --fresh

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
