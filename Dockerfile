# Use a lightweight Ruby image
FROM ruby:3.0.0-alpine

# Install essential packages and dependencies
RUN apk update && \
    apk add --no-cache build-base postgresql-dev nodejs yarn tzdata git nano redis curl supervisor

# Set environment variables for Rails and Google Cloud
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV SECRET_KEY_BASE="your_secret_key_base_here"
ENV DATABASE_URL="postgres://dummyuser:dummypassword@localhost/dummydb"

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to install dependencies
COPY Gemfile Gemfile.lock ./

# Install bundler and gems
RUN gem install bundler && bundle config set --local without 'development test' && bundle install

# Copy the rest of the application code
COPY . .

# Install Node modules for Rails frontend assets
RUN yarn install --check-files

# Precompile assets (optional if it was causing issues)
# RUN bundle exec rails assets:precompile

# Expose the port your app runs on for Cloud Run compatibility
EXPOSE 8080

# Start the Rails server on port 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

