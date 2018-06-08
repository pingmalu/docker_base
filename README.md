# docker_base
ubuntu 18.04


## build

	docker build .

## run

	docker run -P -v /root/docker_FILE/:/app -h base --name base -d [container_id]

## login

	docker exec -it base /bin/bash