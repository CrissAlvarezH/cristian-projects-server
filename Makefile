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

rm-vols:
	docker volume rm cristian-projects-server_db_data
	docker volume rm cristian-projects-server_ubicor-building-images
	docker volume ls
