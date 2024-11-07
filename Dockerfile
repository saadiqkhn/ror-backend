# Use the official Ruby image as the base
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --fix-missing curl gnupg postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs yarn

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code
COPY . .

# Set the Rails environment and placeholder DATABASE_URL
ENV RAILS_ENV production
ENV DATABASE_URL="postgres://user:password@localhost/dbname"

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose the app on port 8080 for Cloud Run compatibility
EXPOSE 8080

# Start the Rails server on port 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

