#!/bin/bash
# ------------------------------------------------------------------------------
if [ -z "$BASH_VERSION" ]; then exec /bin/bash "$0" "$@"; fi
if [ -f /.dockerenv ]; then echo "Error: Inside a container."; exit 1; fi
if [ ! -f .env ]; then echo "Error: File .env not found!"; exit 1; fi;
if [ -z "$1" ]; then option="default"; else option="${1#--}"; fi
source .env
# ------------------------------------------------------------------------------
if [ "$option" = "default" ]; then
if ! docker network ls --format '{{.Name}}' | grep -q "^${SERVICE_NETWORK}$"; then
docker network create "${SERVICE_NETWORK}"
fi
docker pull ubuntu:latest
docker run -dit --name $SERVICE_NAME --network $SERVICE_NETWORK \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd):$SERVICE_NAME" -p $SERVICE_PORT:2310 ubuntu:latest
fi
# ------------------------------------------------------------------------------
if [ "$option" = "dev" ]; then
docker start $SERVICE_NAME
docker exec -i $SERVICE_NAME bash -c "\
  export DEBIAN_FRONTEND=noninteractive && \
  ln -fs /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
  echo \\\"Europe/Rome\\\" > /etc/timezone && \
  apt-get update && apt-get install -y tzdata && \
  dpkg-reconfigure -f noninteractive tzdata" && echo "Timezone installato."
docker exec -i $SERVICE_NAME bash -c "\
  apt-get update && apt-get install -y --no-install-recommends \
  apt-utils nano clang make curl git python3 \
  autoconf libtool-bin libexpat1-dev cmake libssl-dev libmariadb-dev libpq-dev \
  libsqlite3-dev unixodbc-dev libapr1-dev libaprutil1-dev libaprutil1-dbd-mysql \
  libaprutil1-dbd-pgsql libaprutil1-dbd-sqlite3 libjson-c-dev libjwt-dev siege \
  valgrind doxygen graphviz nlohmann-json3-dev libgtest-dev apt-file docker.io \
  gdb ca-certificates mysql-client && apt-get clean && rm -rf /var/lib/apt/lists/*" \
  && echo "Dev packages installed."
docker exec -i $SERVICE_NAME bash -c "\
  cd $SERVICE_NAME \
  && git clone https://github.com/riccardovacirca/microservice.git ${SERVICE_NAME}" \
  && echo "Microservice installed."
docker exec -i $SERVICE_NAME bash -c "\
  cd $SERVICE_NAME \
  && git clone https://github.com/riccardovacirca/mongoose.git mongoose \
  && rm -rf mongoose/.git" && echo "Mongoose installed."
docker exec -i $SERVICE_NAME bash -c "\
  cd $SERVICE_NAME \
  && git clone https://github.com/riccardovacirca/Unity.git unity \
  && rm -rf unity/.git" && echo "Unity installed."
docker exec -i $SERVICE_NAME bash -c "\
  echo \"alias cls='clear'\" >> /etc/bash.bashrc && source /etc/bash.bashrc"
docker exec -i $SERVICE_NAME bash -c "\
  cd $SERVICE_NAME \
  && git config --global --add safe.directory $SERVICE_NAME \
  && git config user.name \"$GITHUB_USER\" \
  && git config user.email \"$GITHUB_MAIL\" \
  && git config user.name && git config user.email" && echo "Git configured."
docker exec -i $SERVICE_NAME bash -c "\
  apt-get install -y language-pack-en; \
  locale-gen en_US.UTF-8; \
  update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8; \
  locale;"
fi
# ------------------------------------------------------------------------------
if [ "$option" = "db-server" ]; then
docker pull mariadb:latest
docker run -d --name mariadb --network $SERVICE_NETWORK \
  -e MARIADB_ROOT_PASSWORD=$DB_ROOT_PASSWORD -p 3306:3306 \
  mariadb:latest
docker start mariadb
# ------------------------------------------------------------------------------
if [ "$option" = "db-root" ]; then
docker exec -i mariadb bash -c "\
  mysql -h 127.0.0.1 -uroot -p$DB_ROOT_PASSWORD -e \" \
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' \
  IDENTIFIED BY '$DB_ROOT_PASSWORD' WITH GRANT OPTION; \
  FLUSH PRIVILEGES;\"  2>/dev/null " && echo "Root privileges installed."
fi
# ------------------------------------------------------------------------------
if [ "$option" = "db-client" ]; then
docker exec -i mariadb bash -c "\
  apt-get update && apt-get install -y --no-install-recommends \
  mysql-client && apt-get clean && rm -rf /var/lib/apt/lists/*"
fi
# ------------------------------------------------------------------------------
if [ "$option" = "db-client" ]; then
docker exec -i mariadb bash -c "\
  mysql -h 127.0.0.1 -uroot ${ROOT_PASSWORD_OPT} -e \"
  CREATE DATABASE IF NOT EXISTS $SERVICE_NAME;
  CREATE USER IF NOT EXISTS '$SERVICE_NAME'@'%' \
  IDENTIFIED BY '$DB_PASSWORD';
  GRANT ALL PRIVILEGES ON $SERVICE_NAME.* \
  TO '$SERVICE_NAME'@'%' WITH GRANT OPTION;
  FLUSH PRIVILEGES;\""
fi
# ------------------------------------------------------------------------------
