FROM ruby:3.3-slim
WORKDIR /app
# Install build essentials for native gem compiled extensions
RUN apt-get update && apt-get install -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*
COPY Gemfile* ./
RUN bundle config set --local deployment 'true' && bundle install
COPY . .
EXPOSE 8086
CMD ["bundle", "exec", "ruby", "app.rb"]
