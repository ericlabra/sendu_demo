APP=web
DC=docker-compose

.PHONY: build up down restart logs shell console setup db-create db-migrate db-reset test

build:
	$(DC) build --no-cache

up:
	$(DC) up -d

down:
	$(DC) down

restart: down up

logs:
	$(DC) logs -f

shell:
	$(DC) exec $(APP) bash

bundle:
	$(DC) exec $(APP) bundle install

console:
	$(DC) exec $(APP) bundle exec rails console

setup: build up db-create db-migrate

db-create:
	$(DC) exec $(APP) bundle exec rails db:create

db-migrate:
	$(DC) exec $(APP) bundle exec rails db:migrate

db-reset:
	$(DC) exec $(APP) bundle exec rails db:drop db:create db:migrate

rubocop:
	$(DC) exec $(APP) bundle exec rubocop

rubocop-safe-correct:
	$(DC) exec $(APP) bundle exec rubocop -a

rubocop-auto-correct:
	$(DC) exec $(APP) bundle exec rubocop -A

test:
	$(DC) exec $(APP) bundle exec rspec

test-watch:
	$(DC) exec $(APP) bundle exec rspec --format documentation
