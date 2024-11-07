# Use the official Ruby image as the base
FROM ruby:3.1.0

# Install dependencies using NodeSource for Node.js
RUN apt-get update -qq && \
    apt-get install -y --fix-missing curl gnupg postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

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



