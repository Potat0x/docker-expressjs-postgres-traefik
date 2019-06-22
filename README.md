## Integrate Docker containers: Exppress.js + Postgres + [Traefik](https://github.com/containous/traefik)

Run `./example.sh`, it will launch two Node.js apps (each app use own Postgres container) and Traefik. Then visit

http://app1.localhost/pgtest

http://app2.localhost/pgtest

http://127.0.0.1:8085/dashboard (Traefik dashboard)
