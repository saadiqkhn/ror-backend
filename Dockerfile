# Use the official Ruby image as the base
FROM ruby:3.1.0

# Use a different Debian mirror and install dependencies
RUN sed -i 's|http://deb.debian.org|http://ftp.us.debian.org|g' /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y --fix-missing nodejs postgresql-client

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code
COPY . .

# Set the Rails environment to production for Cloud Run
ENV RAILS_ENV production

# Precompile assets (optional if the app has frontend assets)
RUN bundle exec rake assets:precompile

# Expose the app on port 8080 for Cloud Run compatibility
EXPOSE 8080

# Start the Rails server on port 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]



