#!/bin/bash

docker build -t potat0x/nodeexample .

docker stop ex_traefik ex_app1 ex_app2 ex_app1postgres ex_app2postgres 

docker run --rm -P -d -p 80:80 -p 8085:8080 \
    --name ex_traefik \
    --network traefik_default \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    traefik --api --docker --docker.watch


# launch first app

docker run --rm -d -p 5432 \
    --name ex_app1postgres \
    -e POSTGRES_PASSWORD=docker \
    -v $HOME/docker/volumes/ex_app1postgres_data:/var/lib/postgresql/data \
    postgres

docker run --rm -P -d \
    --name ex_app1 \
    -e POSTGRES_HOST=ex_app1postgres \
    -e POSTGRES_PASSWORD=docker \
    --network traefik_default \
    --label traefik.frontend.rule="Host:app1.localhost" \
    --label traefik.docker.network="traefik_default" \
    potat0x/nodeexample

docker network rm ex_app1_db_network
docker network create  ex_app1_db_network --attachable

docker network connect ex_app1_db_network ex_app1postgres
docker network connect ex_app1_db_network ex_app1


# launch second app, in the same way

docker run --rm -d -p 5432 \
    --name ex_app2postgres \
    -e POSTGRES_PASSWORD=docker \
    -v $HOME/docker/volumes/ex_app2postgres_data:/var/lib/postgresql/data \
    postgres

docker run --rm -P -d \
    --name ex_app2 \
    -e POSTGRES_HOST=ex_app2postgres \
    -e POSTGRES_PASSWORD=docker \
    --network traefik_default \
    --label traefik.frontend.rule="Host:app2.localhost" \
    --label traefik.docker.network="traefik_default" \
    potat0x/nodeexample

docker network rm ex_app2_db_network
docker network create  ex_app2_db_network --attachable

docker network connect ex_app2_db_network ex_app2postgres
docker network connect ex_app2_db_network ex_app2


sleep 3 # wait for databases (ugly, but ok for this simple example)

docker exec ex_app1postgres psql -U postgres -c \
    "create table if not exists hello_world(txt text); \
    insert into hello_world values('app1: postgres ok');"
    
docker exec ex_app2postgres psql -U postgres -c \
    "create table if not exists hello_world(txt text); \
    insert into hello_world values('app2: postgres ok');"
