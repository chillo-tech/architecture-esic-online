# Architecture des données

## Actions

### Créer un réseau sur le serveur

```
docker network create applications-network
```

### Lancer le job github actions

```
docker network create applications-network
```

### dump database

```
docker exec -i CONTAINER_NAME /bin/bash -c "pg_dump -h DB_HOST -d DB_NAME -U DB_USERNAME" > DUMPED_FILE.sql
```

### restore database

```
docker exec -i esic-online-database /bin/bash -c 'PGPASSWORD=z5Yh@bwht@vmfY\*!M)Nc9BQ%a psql -h esic-online-database -d esic-online-database -U online-database' < esic-online-database06022023.sql
```

docker exec -i esic-online-database /bin/bash -c "PGPASSWORD=9BSHF492PEAU9AJYJU98X9XEA psql -h esic-online-database -d esic-online-database -U online-database -v"