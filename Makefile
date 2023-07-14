include .env

.PHONY: dev env/setup env/teardown codebase codebase/fix

dev:
	make install-dependencies
	make env/setup
	bundle exec ./bin/dev

env/setup:
	bundle exec ./bin/envsetup.sh
	bundle exec rails db:prepare

env/teardown:  # this command will delete data
	bundle exec ./bin/envteardown.sh

install-dependencies:
	bundle install
	yarn install

codebase:
	bundle exec rubocop

codebase/fix:
	bundle exec rubocop -a
