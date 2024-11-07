# Use the official Ruby image as the base
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --fix-missing curl gnupg build-essential libpq-dev nodejs yarn

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code
COPY . .

# Install JavaScript dependencies with Yarn (for Webpacker)
RUN yarn install

# Set environment variables for precompilation
ENV RAILS_ENV production
ENV DATABASE_URL="postgres://user:password@localhost/dbname"
ENV SECRET_KEY_BASE="dummysecretkey"
ENV RAILS_MASTER_KEY="dummyrailskey"

# Precompile assets
RUN bundle exec rake assets:precompile --trace

# Expose the app on port 8080 for Cloud Run compatibility
EXPOSE 8080

# Start the Rails server on port 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

