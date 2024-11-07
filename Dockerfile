# Use the official Ruby image as the base
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --fix-missing curl gnupg build-essential libpq-dev && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code (including package.json if it exists)
COPY . .

# Install JavaScript dependencies with Yarn (for Webpacker)
RUN yarn install

# Set environment variables for precompilation
ENV RAILS_ENV production
ENV DATABASE_URL="postgres://dummyuser:dummypassword@localhost/dummydb"
ENV SECRET_KEY_BASE="dummysecretkey"
ENV RAILS_MASTER_KEY="dummyrailskey"

# Print environment variables for debugging
RUN echo "DATABASE_URL=$DATABASE_URL" && \
    echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" && \
    echo "RAILS_MASTER_KEY=$RAILS_MASTER_KEY"

# Precompile assets
#RUN bundle exec rake assets:precompile --trace

# Expose the app on port 8080 for Cloud Run compatibility
EXPOSE 8080

# Start the Rails server on port 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

