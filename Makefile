# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS

# Build the container
create: ## construct the containers
	docker-compose create 

dev: ## run container in development mode
	# TODO: Load Ligero in "DEV Mode".
	# Use Makefile to download code from github like scripts in https://github.com/complemento/docker.ligero_dev
	docker-compose run 

up: ## run the container and show logs
	docker-compose pull
	docker-compose up 

run: ## run stack
	docker-compose run 

start: ## start all containers 
	docker-compose start 

console: ## open console app
	docker-compose exec webserver bash

stop: ## stop all containers 
	docker-compose stop 

restart: stop start ## restart all containers

rm: stop ## stop and remove containers
	docker-compose rm 

set-permissions: ## fix files permission on /opt/otrs
	docker-compose exec webserver bin/otrs.SetPermissions.pl --web-group=www-data

backup: ## run backup.pl on the webserver
	docker-compose exec webserver /opt/otrs/scripts/backup.pl -d /app-backups

restore: ## restore backup from BACKUP_DATE param format like YYYY-MM-DD_HH-mm
	docker-compose exec webserver test -f "/app-backups/$(BACKUP_DATE)/Config.tar.gz"
	docker-compose exec webserver /opt/otrs/scripts/restore.pl -d /opt/otrs/ -b /app-backups/$(BACKUP_DATE)

cron-enable-backup: ## activate daily backup with crontab
	docker-compose exec webserver test -f /opt/otrs/var/cron/app-backups.dist
	docker-compose exec webserver bin/Cron.sh stop otrs
	docker-compose exec webserver mv var/cron/app-backups.dist var/cron/app-backups
	docker-compose exec webserver bin/Cron.sh start otrs

cron-disable-backup: ## deactivate daily backup with crontab
	docker-compose exec webserver test -f /opt/otrs/var/cron/app-backups
	docker-compose exec webserver bin/Cron.sh stop otrs
	docker-compose exec webserver mv var/cron/app-backups var/cron/app-backups.dist
	docker-compose exec webserver bin/Cron.sh start otrs

tail-error-log: ## show apache error log
	docker-compose exec webserver tailf /var/log/apache2/error.log

daemon-stop: ## stop Daemon
	docker-compose exec -u otrs webserver bin/otrs.Daemon.pl stop

daemon-start: ## start Daemon
	docker-compose exec -u otrs webserver bin/otrs.Daemon.pl start

daemon-restart: daemon-stop daemon-start ## restart Daemon

clean: stop ## clean all containers, networks and volumes
	   docker-compose rm -f -v
	   docker-compose down -v 
