# Use the official Ruby image as the base
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code
COPY . .

# Precompile assets (optional if the app has frontend assets)
RUN bundle exec rake assets:precompile

# Expose the app on port 8080 for Cloud Run compatibility
EXPOSE 8080

# Start the Rails server on port 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

