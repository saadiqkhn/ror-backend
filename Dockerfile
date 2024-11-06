# Use an official Ruby runtime as a parent image
FROM ruby:3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory
WORKDIR /app

# Copy the Gemfile and install gems
COPY Gemfile* /app/
RUN bundle install

# Copy the Rails application
COPY . /app

# Precompile assets for production (optional)
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Expose the Rails server port
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
