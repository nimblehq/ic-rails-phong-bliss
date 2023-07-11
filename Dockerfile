FROM ruby:3.0.1-slim

ARG BUILD_ENV=development
ARG RUBY_ENV=development
ARG APP_HOME=/google_search_ruby

# Define all the envs here
ENV BUILD_ENV=$BUILD_ENV \
    RACK_ENV=$RUBY_ENV \
    RAILS_ENV=$RUBY_ENV \
    PORT=3000 \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH="/bundle" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NODE_ENV=$NODE_ENV \
    NODE_VERSION=20 \
    AVAILABLE_LOCALES="en" \
    DATABASE_URL="postgres://yurtoicscbglrx:c7c4edbf14b3b8b489fe4bc87ab212e3eabdc538b491e98ab2ef247c69c293e7@ec2-3-234-204-26.compute-1.amazonaws.com:5432/dcsosoect0d24n" \
    DEFAULT_LOCALE="en" \
    FALLBACK_LOCALES="en" \
    MAILER_DEFAULT_HOST="rails-ic-phong-bliss-staging.herokuapp.com" \
    MAILER_DEFAULT_PORT="80" \
    MAILER_SENDER="Test <noreplyrailsic@gmail.com>" \
    RAILS_LOG_TO_STDOUT="true" \
    RAILS_MASTER_KEY="867ef18d82fbfeaa8a4342a1845d7563" \
    REDIS_TLS_URL="rediss://:pc46c6ac087628da38d8183c00a8b37822d5fdf1bf98b5b11f769e23453997f3e@ec2-54-174-37-64.compute-1.amazonaws.com:22910" \
    REDIS_URL="redis://:pc46c6ac087628da38d8183c00a8b37822d5fdf1bf98b5b11f769e23453997f3e@ec2-54-174-37-64.compute-1.amazonaws.com:22909" \
    SMTP_MAIL_SERVER="smtp.gmail.com" \
    SMTP_PORT="587"

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends apt-transport-https curl gnupg net-tools && \
    apt-get install -y --no-install-recommends build-essential libpq-dev && \
    apt-get install -y --no-install-recommends rsync locales chrpath pkg-config libfreetype6 libfontconfig1 git cmake wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up the Chrome PPA and install Chrome Headless
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install yarn
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_"$NODE_VERSION".x | bash - && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends nodejs yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR $APP_HOME

# Skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
    echo '---'; \
    echo ':update_sources: true'; \
    echo ':benchmark: false'; \
    echo ':backtrace: true'; \
    echo ':verbose: true'; \
    echo 'gem: --no-ri --no-rdoc'; \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

# Copy all denpendencies from app and engines into tmp/docker to install
COPY tmp/docker ./

# Install Ruby gems
RUN gem install bundler && \
    bundle config set jobs $BUNDLE_JOBS && \
    bundle config set path $BUNDLE_PATH && \
    if [ "$BUILD_ENV" = "production" ]; then \
      bundle config set deployment yes && \
      bundle config set without 'development test' ; \
    fi && \
    bundle install

# Install JS dependencies
COPY package.json yarn.lock .yarnrc ./
RUN yarn install

# Copying the app files must be placed after the dependencies setup
# since the app files always change thus cannot be cached
COPY . ./
# Remove tmp/docker in the final image
RUN rm -rf tmp/docker

EXPOSE $PORT

CMD ./bin/start.sh
