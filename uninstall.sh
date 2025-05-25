#!/bin/bash
# ------------------------------------------------------------------------------
if [ -z "$BASH_VERSION" ]; then exec /bin/bash "$0" "$@"; fi
if [ -f /.dockerenv ]; then echo "Error: Inside a container."; exit 1; fi
if [ ! -f .env ]; then echo "Error: File .env not found!"; exit 1; fi;
if [ "$EUID" -ne 0 ]; then echo "Esegui lo script con sudo o come root."; exit 1; fi
# ------------------------------------------------------------------------------
source .env
# ------------------------------------------------------------------------------
rm -rf mongoose && echo "Mongoose rimosso."
# ------------------------------------------------------------------------------
rm -rf unity && echo "Unity rimosso."
# ------------------------------------------------------------------------------
rm -rf microservice && echo "microservice rimosso."
# ------------------------------------------------------------------------------
rm -rf bin && echo "Directory bin rimossa."
# ------------------------------------------------------------------------------
rm -rf tmp && echo "Directory tmp rimossa."
# ------------------------------------------------------------------------------
rm -rf .github && echo "Directory .github rimossa."
# ------------------------------------------------------------------------------
echo "Arresto il container $SERVICE_NAME..." \
  && docker stop $SERVICE_NAME && docker rm $SERVICE_NAME \
  && echo "Container $SERVICE_NAME rimosso."
# ------------------------------------------------------------------------------
echo "Arresto il container mariadb..." \
  && docker stop mariadb && docker rm mariadb \
  && echo "Container mariadb rimosso."
# ------------------------------------------------------------------------------
docker system prune -a --volumes && echo "System prune eseguito."
# ------------------------------------------------------------------------------
exit 0
