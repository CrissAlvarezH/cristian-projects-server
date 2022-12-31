generate-env:
	sh manage.sh generate-env

start:
	sh manage.sh start

update:
	sh manage.sh update

down:
	docker compose down

reboot:
	make down
	make start
