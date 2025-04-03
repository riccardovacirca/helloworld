#!/bin/bash
# ==============================================================================
# Copyright (C) 2023-2025  Riccardo Vacirca
# All rights reserved
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see
# <https://www.gnu.org/licenses/>.
# ==============================================================================
if [ -z "$BASH_VERSION" ]; then exec /bin/bash "$0" "$@"; fi
# ==============================================================================
if [ -f /.dockerenv ]; then
  echo "Non puoi eseguire questa installazione all'interno di un container."
  echo ""
  exit 1
fi
# ==============================================================================
# INSTALL OPTIONS
# ==============================================================================
STEPS="y"
if [ -z "$1" ]; then
  option="default"
else
  option="${1#--}"
  if [ -n "$2" ]; then
    option_ext="${2#--}"
    if [ "$option_ext" = "yes" ]; then
      STEPS="n"
    fi
  fi
  if [ "$option" = "yes" ]; then
    STEPS="n"
  fi
fi
# ==============================================================================
# CONFIG
# ==============================================================================
SERVICE_NAME=$(basename "$PWD")
SERVICE_AUTHOR=""
SERVICE_DESCRIPTION="C/C++ microservice"
SERVICE_URI=""
SERVICE_CMD="/usr/bin/${SERVICE_NAME}"
SERVICE_BIN="bin/${SERVICE_NAME}"
SERVICE_HOST="0.0.0.0"
SERVICE_PORT=8090
SERVICE_TLS_PORT=8092
SERVICE_WEB_PORT=8094
SERVICE_WS_PORT=8096
SERVICE_LOG="/var/log/${SERVICE_NAME}.log"
SERVICE_PID_FILE="/run/${SERVICE_NAME}.pid"
SERVICE_JWT_KEY="jwt-key-secret"
SERVICE_NETWORK="${SERVICE_NAME}-net"
SERVICE_DOCKER_IMAGE="ubuntu:latest"
SERVICE_WORKING_DIR="/${SERVICE_NAME}"
SERVICE_INSTALL_DIR="/opt/microservices"
SERVICE_DEV_DEPENDENCIES="apt-utils nano clang make curl git python3 \
autoconf libtool-bin libexpat1-dev cmake libssl-dev libmariadb-dev libpq-dev \
libsqlite3-dev unixodbc-dev libapr1-dev libaprutil1-dev libaprutil1-dbd-mysql \
libaprutil1-dbd-pgsql libaprutil1-dbd-sqlite3 libjson-c-dev libjwt-dev siege \
valgrind doxygen graphviz nlohmann-json3-dev libgtest-dev apt-file docker.io \
ca-certificates mysql-client"
SERVICE_DEPENDENCIES="curl libssl3 libmariadb3 libpq5 libsqlite3-0 unixodbc \
libjson-c5 libapr1 libaprutil1 libaprutil1-dbd-mysql libaprutil1-dbd-pgsql \
libaprutil1-dbd-sqlite3 libjwt2 wget gnupg"
DB_IMAGE=""
DB_CONTAINER=""
DB_SERVER="mariadb"
DB_DRIVER="mysql"
DB_HOST="mariadb"
DB_PORT="3306"
DB_ROOT_PASSWORD=""
DB_PASSWORD=""
DB_SCHEMA="database/mariadb-schema.sql"
DB_DATA="database/mariadb-data.sql"
GITHUB_USER=""
GITHUB_MAIL=""
GITHUB_TOKEN=""
BENCH_CONCURRENCE=1
BENCH_TIME=10s
MICROSERVICE_GITHUB_REPO="https://github.com/riccardovacirca/microservice.git"
MICROSERVICE_DIR="microservice"
MONGOOSE_GITHUB_REPO="https://github.com/riccardovacirca/mongoose.git"
MONGOOSE_DIR="mongoose"
UNITY_GITHUB_REPO="https://github.com/riccardovacirca/Unity.git"
UNITY_DIR="unity"
CPPJWT_GITHUB_REPO="https://github.com/riccardovacirca/cpp-jwt.git"
CPPJWT_DIR="cppjwt"
# ==============================================================================
# HELP
# ==============================================================================
if [ "$option" = "help" ]; then
  VERS="v0.0.1"
  if [ -f VERSION ]; then VERS=$(cat VERSION); fi
  echo "Uso: ./install.sh [OPZIONI [--STEPS]]"
  echo ""
  echo "Opzioni:"
  echo "    --env        Installa il file .env di configurazione"
  echo "    --env-test   Installa il file .env di test"
  echo "    --release    Installa la versione di rilascio"
  echo "    --purge      Esegue il purge dell'installazione"
  echo "    --doc        Genera la documentazione con Doxygen"
  echo "    --gh-repo    Genera il repo Github per il progetto"
  echo "    --test       Installa l'ambiente con una configurazione di test"
  echo "    --help       Mostra questo messaggio"
  echo ""
  exit 0
fi
# ==============================================================================
# ENV
# ==============================================================================
if [ "$option" = "env" ]; then
  if [ -f .env ]; then
    echo "Il file .env esiste!"
    exit 1
  fi
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Creare un file .env? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > ".env" << EOF
SERVICE_NAME="${SERVICE_NAME}"
SERVICE_AUTHOR="${SERVICE_AUTHOR}"
SERVICE_DESCRIPTION="${SERVICE_DESCRIPTION}"
SERVICE_URI="${SERVICE_URI}"
SERVICE_CMD="${SERVICE_CMD}"
SERVICE_BIN="${SERVICE_BIN}"
SERVICE_HOST="${SERVICE_HOST}"
SERVICE_PORT="${SERVICE_PORT}"
SERVICE_TLS_PORT="${SERVICE_TLS_PORT}"
SERVICE_WEB_PORT="${SERVICE_WEB_PORT}"
SERVICE_WS_PORT="${SERVICE_WS_PORT}"
SERVICE_LOG="${SERVICE_LOG}"
SERVICE_PID_FILE="${SERVICE_PID_FILE}"
SERVICE_JWT_KEY="${SERVICE_JWT_KEY}"
SERVICE_DOCKER_IMAGE="${SERVICE_DOCKER_IMAGE}"
SERVICE_WORKING_DIR="${SERVICE_WORKING_DIR}"
SERVICE_INSTALL_DIR="${SERVICE_INSTALL_DIR}"
SERVICE_DEV_DEPENDENCIES="${SERVICE_DEV_DEPENDENCIES}"
SERVICE_DEPENDENCIES="${SERVICE_DEPENDENCIES}"
SERVICE_NETWORK="${SERVICE_NETWORK}"
GITHUB_USER="${GITHUB_USER}"
GITHUB_MAIL="${GITHUB_MAIL}"
GITHUB_TOKEN="${GITHUB_TOKEN}"
BENCH_CONCURRENCE=$BENCH_CONCURRENCE
BENCH_TIME=$BENCH_TIME
DB_IMAGE="${DB_IMAGE}"
DB_CONTAINER="${DB_CONTAINER}"
DB_SERVER="${DB_SERVER}"
DB_DRIVER="${DB_DRIVER}"
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"
DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD}"
DB_PASSWORD="${DB_PASSWORD}"
DB_SCHEMA="${DB_SCHEMA}"
DB_DATA="${DB_DATA}"
MICROSERVICE_GITHUB_REPO="${MICROSERVICE_GITHUB_REPO}"
MICROSERVICE_DIR="${MICROSERVICE_DIR}"
MONGOOSE_GITHUB_REPO="${MONGOOSE_GITHUB_REPO}"
MONGOOSE_DIR="${MONGOOSE_DIR}"
UNITY_GITHUB_REPO="${UNITY_GITHUB_REPO}"
UNITY_DIR="${UNITY_DIR}"
CPPJWT_GITHUB_REPO="${CPPJWT_GITHUB_REPO}"
CPPJWT_DIR="${CPPJWT_DIR}"
EOF
  fi
  if [ -f .env ]; then echo "File .env creato.";
  else echo "File .env non creato."; fi;
  exit 0
fi
# ==============================================================================
# ENV TEST
# ==============================================================================
if [ "$option" = "env-test" ]; then
  if [ -f .env ]; then echo "Error: .env file exists!"; exit 1; fi;
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Creare un file .env di test? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > ".env" << EOF
SERVICE_NAME="${SERVICE_NAME}"
SERVICE_CMD="${SERVICE_CMD}"
SERVICE_BIN="${SERVICE_BIN}"
SERVICE_HOST="${SERVICE_HOST}"
SERVICE_PORT="${SERVICE_PORT}"
SERVICE_TLS_PORT="${SERVICE_TLS_PORT}"
SERVICE_WEB_PORT="${SERVICE_WEB_PORT}"
SERVICE_WS_PORT="${SERVICE_WS_PORT}"
SERVICE_LOG="${SERVICE_LOG}"
SERVICE_PID_FILE="${SERVICE_PID_FILE}"
SERVICE_JWT_KEY="secret-jwt-key"
SERVICE_DOCKER_IMAGE="${SERVICE_DOCKER_IMAGE}"
SERVICE_WORKING_DIR="${SERVICE_WORKING_DIR}"
SERVICE_INSTALL_DIR="${SERVICE_INSTALL_DIR}"
SERVICE_DEV_DEPENDENCIES="${SERVICE_DEV_DEPENDENCIES}"
SERVICE_NETWORK="${SERVICE_NETWORK}"
SERVICE_DEPENDENCIES="${SERVICE_DEPENDENCIES}"
DB_IMAGE="mariadb:latest"
DB_CONTAINER="mariadb"
DB_SERVER="${DB_SERVER}"
DB_DRIVER="${DB_DRIVER}"
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"
DB_ROOT_PASSWORD="root"
DB_PASSWORD="secret"
DB_SCHEMA="${DB_SCHEMA}"
DB_DATA="${DB_DATA}"
BENCH_CONCURRENCE=$BENCH_CONCURRENCE
BENCH_TIME=$BENCH_TIME
MICROSERVICE_GITHUB_REPO="${MICROSERVICE_GITHUB_REPO}"
MICROSERVICE_DIR="${MICROSERVICE_DIR}"
MONGOOSE_GITHUB_REPO="${MONGOOSE_GITHUB_REPO}"
MONGOOSE_DIR="${MONGOOSE_DIR}"
UNITY_GITHUB_REPO="${UNITY_GITHUB_REPO}"
UNITY_DIR="${UNITY_DIR}"
CPPJWT_GITHUB_REPO="${CPPJWT_GITHUB_REPO}"
CPPJWT_DIR="${CPPJWT_DIR}"
EOF
  fi
  if [ -f .env ]; then echo "File .env di test creato.";
  else echo "File .env di test non creato."; fi;
  exit 0
fi
# ==============================================================================
# TEST
# ==============================================================================
if [ "$option" = "test" ]; then
  if [ "${STEPS}" = "y" ]; then ./install.sh --env-test;
  else ./install.sh --env-test --yes; fi; if [ $? -eq 1 ]; then exit 1; fi;
fi
# ==============================================================================
if [ ! -f .env ]; then echo "Error: File .env non trovato!"; exit 1; fi;
# ==============================================================================
source .env
# ==============================================================================
# PURGE
# ==============================================================================
if [ "$option" = "purge" ]; then
  
  STEP="n"; while true; do
  # ----------------------------------------------------------------------------
  read -p "Eseguire il purge dell'installazione? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done;
  if [ "${STEP}" != "y" ]; then exit 0; fi;
  
  if [ "$EUID" -ne 0 ]; then
    echo "Esegui lo script con sudo o come root."
    exit 1
  fi
  
  echo "Eseguo il purge dell'installazione..."

  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Eseguire un backup del file .env? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cp .env env && echo "Backup del file .env eseguito."
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere CPP-JWT? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf cppjwt && echo "CPP-JWT rimosso."
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere Mongoose? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf mongoose && echo "Mongoose rimosso."
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere Unity? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf unity && echo "Unity rimosso."
  fi

  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere microservice? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf microservice && echo "microservice rimosso."
  fi

  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere la diretory bin/? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf bin && echo "Directory bin rimossa."
  fi

  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere la directory tmp/? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf tmp && echo "Directory tmp rimossa."
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Rimuovere la directory .github? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    rm -rf .github && echo "Directory .github rimossa."
  fi

  if [ -n "$(docker ps -a -q -f name=${SERVICE_NAME})" ]; then
    STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
    # --------------------------------------------------------------------------
    read -p "Rimuovere il container ${SERVICE_NAME}? (y/N/s=stop) " STEP;
    # --------------------------------------------------------------------------
    case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
    if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
      echo "Arresto il container $SERVICE_NAME..." \
      && docker stop $SERVICE_NAME && docker rm $SERVICE_NAME \
      && echo "Container $SERVICE_NAME rimosso."
    fi
  fi
  
  if [ -n "$(docker ps -a -q -f name=${DB_CONTAINER})" ]; then
    STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
    # --------------------------------------------------------------------------
    read -p "Rimuovere il container ${DB_CONTAINER}? (y/N/s=stop) " STEP;
    # --------------------------------------------------------------------------
    case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
    if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
      echo "Arresto il container $DB_CONTAINER..." \
      && docker stop $DB_CONTAINER && docker rm $DB_CONTAINER \
      && echo "Container $DB_CONTAINER rimosso."
    fi
  fi
  # ============================================================================
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Eseguire 'system prune -a --volumes'? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker system prune -a --volumes \
    && echo "System prune eseguito."
  fi

  echo "Purge dell'installazione completato."
  exit 0
fi
# ==============================================================================
# DOC
# ==============================================================================
if [ "$option" = "doc" ]; then
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Creare la directory 'doc'? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    mkdir -p doc && echo "Directory doc creata."
  fi
  
  if [ ! -d "doc" ]; then
    echo "Directory doc non creata. Termino."
    exit 1
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Creare il Doxyfile? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > Doxyfile << EOF
PROJECT_NAME=${SERVICE_NAME}
INPUT=${SERVICE_NAME}.cpp
OUTPUT_DIRECTORY=doc
GENERATE_HTML=YES
GENERATE_LATEX=NO
EOF
    echo "Doxyfile creato."
    
    STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
    # --------------------------------------------------------------------------
    read -p "Eseguire doxygen? (y/N/s=stop) " STEP;
    # --------------------------------------------------------------------------
    case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
    if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
      docker exec -i $SERVICE_NAME bash -c "\
      cd ${SERVICE_WORKING_DIR} && doxygen Doxyfile && rm Doxyfile" \
      && echo "Doxygen eseguito."
    fi
  
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Creare il file index.html? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > doc/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${SERVICE_NAME}</title>
</head>
<body>
  <h1>${SERVICE_NAME}</h1>
  <h3>${SERVICE_DESCRIPTION}</h3>
</body>
</html>
EOF
    echo "File index.html creato."
  fi
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Creare il file doc/CNAME? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    if [ -n "${SERVICE_URI}" ]; then
      echo "${SERVICE_URI}" > doc/CNAME && echo "File CNAME creato."
    else
      echo "www.example.com" > doc/CNAME && echo "File CNAME creato."
    fi
  fi
  
  exit 0
fi
# ==============================================================================
# DOC-REPO
# ==============================================================================
if [ "$option" = "doc-repo" ]; then
  mkdir -p doc
  if [ -n "${GITHUB_USER}" ] && [ -n "${GITHUB_MAIL}" ]; then
    if [ -n "${GITHUB_TOKEN}" ] && [ -n "${SERVICE_URI}" ]; then
      STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
      # ------------------------------------------------------------------------
      read -p "Creare il repo ${SERVICE_URI}? (y/N/s=stop) " STEP;
      # ------------------------------------------------------------------------
      case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
      if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
        docker exec -i $SERVICE_NAME bash -c "\
          curl -X POST https://api.github.com/user/repos \
          -H \"Authorization: token ${GITHUB_TOKEN}\" \
          -H \"Accept: application/vnd.github.v3+json\" \
          -d '{\"name\": \"${SERVICE_URI}\", \"private\": false}'" \
          && echo "Repo ${SERVICE_URI} creato."
        STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
        # ----------------------------------------------------------------------
        read -p "Inizializzare il repo doc locale? (y/N/s=stop) " STEP;
        # ----------------------------------------------------------------------
        case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
        if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
          docker exec -i $SERVICE_NAME bash -c "\
            cd ${SERVICE_WORKING_DIR}/doc \
            && git init \
            && git config --global --add safe.directory $SERVICE_WORKING_DIR/doc \
            && git config user.name \"$GITHUB_USER\" \
            && git config user.email \"$GITHUB_MAIL\" \
            && git remote add origin https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${SERVICE_URI}.git \
            && git checkout -b main \
            && git add . \
            && git commit -m \"Initial commit\" \
            && git push -u origin main" \
            && echo "Repo ${SERVICE_URI} inizializzato."
        fi
      fi
    fi
    echo ""
    echo "Associa un dominio al repo dalla sezione Pages su github.com"
  fi
  exit 0
fi
# ==============================================================================
# DOC WORKFLOW
# ==============================================================================
# if [ "$option" = "doc-workflow" ]; then
#   if [ -n "${GITHUB_USER}" ] && [ -n "${GITHUB_MAIL}" ]; then
#     if [ -n "${GH_TOKEN}" ]; then
#       STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
#       # ------------------------------------------------------------------------
#       read -p "Creare un workflow di test per doc? (y/N/s=stop) " STEP;
#       # ------------------------------------------------------------------------
#       case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
#       if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
#         mkdir -p doc/.github/workflows
#         cat > doc/.github/workflows/workflow.yml << EOF
# name: ${SERVICE_NAME} CI/CD Workflow
# on:
#   push:
#     branches:
#       - main
# jobs:
#   branch-main-job:
#     runs-on: ubuntu-latest
#     services:
#       mariadb:
#         image: mariadb:latest
#         env:
#           MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
#         ports:
#           - 3306:3306
#         options: >-
#           --health-cmd="mysqladmin ping -h 127.0.0.1 -u root -p${DB_ROOT_PASSWORD}"
#           --health-interval=10s
#           --health-timeout=5s
#           --health-retries=5
#     steps:
#       - name: Checkout repository
#         uses: actions/checkout@v3
#         with:
#           fetch-depth: 0
#       - name: Wait for MariaDB
#         run: |
#           for i in {1..30}; do
#             mysqladmin ping -h 127.0.0.1 -u root -p${DB_ROOT_PASSWORD} && break
#             echo "Waiting for MariaDB..."
#             sleep 2
#           done
#       - name: Clone repository ${SERVICE_NAME}
#         run: |
#           git clone https://x-access-token:\${{ secrets.GH_TOKEN }}@github.com/${GITHUB_USER}/${SERVICE_NAME}.git ${SERVICE_NAME}
#       - name: Run unit-test
#         run: cd ${SERVICE_NAME} && chmod +x install.sh && ./install.sh --env-test && ./install.sh --test
# EOF
#         echo "Workflow di test creato."
#       fi
#     else
#       echo "GH_TOKEN non settato nel file .env"
#       echo "Crea una github secret 'GH_TOKEN' con un Github token"
#       exit 1
#     fi
#   fi
#   exit 0
# fi
# ==============================================================================
# GH-REPO
# ==============================================================================
if [ "$option" = "gh-repo" ]; then
  if [ -n "$GITHUB_USER" ] && \
     [ -n "$GITHUB_MAIL" ] && [ -n "$GITHUB_TOKEN" ]; then
    if [ -d ".git" ]; then
      echo "La directory .git esiste." 
      exit 1
    fi
    STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
    # --------------------------------------------------------------------------
    read -p "Creare un repository per il servizio? (y/N/s=stop) " STEP;
    # --------------------------------------------------------------------------
    case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
    if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
      REMOTE_URL="https://$GITHUB_TOKEN@github.com/$GITHUB_USER/$SERVICE_NAME.git"
      docker exec -i $SERVICE_NAME bash -c "\
        cd $SERVICE_WORKING_DIR; \
        if [ -d ".git" ]; then \
          rm -rf .git; \
        fi; \
        curl -u \"$GITHUB_USER:$GITHUB_TOKEN\" https://api.github.com/user/repos \
          -d \"{\\\"name\\\":\\\"$SERVICE_NAME\\\", \\\"private\\\":true}\"; \
        if [ $? -eq 0 ]; then \
          cd $SERVICE_WORKING_DIR \
          && git init \
          && git config --global --add safe.directory $SERVICE_WORKING_DIR \
          && git config user.name \"$GITHUB_USER\" \
          && git config user.email \"$GITHUB_MAIL\" \
          && git remote add origin \"$REMOTE_URL\" \
          && git checkout -b main \
          && git add README.md LICENSE \
          && git commit -m \"initial commit\" \
          && git push -u origin main \
          && git checkout -b develop \
          && git push -u origin develop; \
        else \
          echo \"Error: Remote repository not installed!\"; \
        fi;" && echo "Repo ${SERVICE_NAME} creato e inizializzato."
    fi
  fi
  exit 0
fi
# ==============================================================================
# GITHUB WORKFLOWS
# ==============================================================================
# if [ "$option" = "gh-workflows" ]; then
#   if [ ! -d .github ]; then
#     STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
#     # --------------------------------------------------------------------------
#     read -p "Creare un workflow per il branch develop? (y/N/s=stop) " STEP;
#     # --------------------------------------------------------------------------
#  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
#     if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
#       mkdir -p .github/workflows
#       cat > .github/workflows/develop-workflow.yml << EOF
# name: CI/CD Workflow
# on:
#   push:
#     branches:
#       - develop
# jobs:
#   branch-develop-job:
#     runs-on: ubuntu-latest
#     services:
#       mariadb:
#         image: mariadb:latest
#         env:
#           MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
#         ports:
#           - 3306:3306
#         options: >-
#           --health-cmd="mysqladmin ping -h 127.0.0.1 -u root -p${DB_ROOT_PASSWORD}"
#           --health-interval=10s
#           --health-timeout=5s
#           --health-retries=5
#     steps:
#       - name: Checkout repository
#         uses: actions/checkout@v3
#         with:
#           fetch-depth: 0
#       - name: Wait for MariaDB
#         run: |
#           for i in {1..30}; do
#             mysqladmin ping -h 127.0.0.1 -u root -p${DB_ROOT_PASSWORD} && break
#             echo "Waiting for MariaDB..."
#             sleep 2
#           done
#       - name: Checkout repository
#         uses: actions/checkout@v3
#         with:
#           fetch-depth: 0
#       - name: Build unit-test
#         run: ./install.sh --env-test && ./install.sh --test
# EOF
#       echo "Workflow per il branch develop creato."
#     fi
#     STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
#     # --------------------------------------------------------------------------
#     read -p "Creare un workflow per il branch main? (y/N/s=stop) " STEP;
#     # --------------------------------------------------------------------------
#  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
#     if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
#       mkdir -p .github/workflows
#       cat > .github/workflows/main-workflow.yml << EOF
# name: CI/CD Workflow
# on:
#   push:
#     branches:
#       - main
# jobs:
#   branch-main-job:
#     runs-on: ubuntu-latest
#     services:
#       mariadb:
#         image: mariadb:latest
#         env:
#           MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
#         ports:
#           - 3306:3306
#         options: >-
#           --health-cmd="mysqladmin ping -h 127.0.0.1 -u root -p${DB_ROOT_PASSWORD}"
#           --health-interval=10s
#           --health-timeout=5s
#           --health-retries=5
#     steps:
#       - name: Checkout repository
#         uses: actions/checkout@v3
#         with:
#           fetch-depth: 0
#       - name: Wait for MariaDB
#         run: |
#           for i in {1..30}; do
#             mysqladmin ping -h 127.0.0.1 -u root -p${DB_ROOT_PASSWORD} && break
#             echo "Waiting for MariaDB..."
#             sleep 2
#           done
#       - name: Build unit-test
#         run: ./install.sh --env-test && ./install.sh --test
# EOF
#       echo "Workflow per il branch main creato."
#     fi
#   fi
#   exit 0
# fi


# ==============================================================================
# WEBROOT
# ==============================================================================
if [ "$option" = "webroot" ]; then
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ------------------------------------------------------------------------
  read -p "Installare NodeJS e Vite? (y/N/s=stop) " STEP;
  # ------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker exec -i ${SERVICE_NAME} bash -c "\
      curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
      apt-get update && apt-get install -y --no-install-recommends && \
      apt-get clean && rm -rf /var/lib/apt/lists/*nodejs && \
      npm create vite webroot --template svelte"
  fi
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ------------------------------------------------------------------------
  read -p "Creare il file vite.config.ts? (y/N/s=stop) " STEP;
  # ------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > webroot/vite.config.ts << EOF
import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'
export default defineConfig({
  plugins: [svelte()],
  server: {
    host: '0.0.0.0',
    port: 23100,
    proxy: {
      '/api': {
        target: 'http://localhost:2310',
        changeOrigin: true,
        secure: false
      }
    }
  },
  build: {
    outDir: './dist',
    emptyOutDir: true,
    assetsDir: './'
  }
})
EOF
  fi
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ------------------------------------------------------------------------
  read -p "Creare il file index.html? (y/N/s=stop) " STEP;
  # ------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > webroot/index.html << EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>index</title>
  </head>
  <body>
    <div id="main"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
EOF
  fi
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ------------------------------------------------------------------------
  read -p "Creare il file src/main.ts? (y/N/s=stop) " STEP;
  # ------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > webroot/src/main.ts << EOF
import { mount } from 'svelte'
import HelloWorld from './lib/HelloWorld.svelte';
mount(HelloWorld, { target: document.getElementById('main') });
EOF
  fi
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ------------------------------------------------------------------------
  read -p "Creare il componente lib/HelloWorld.svelte? (y/N/s=stop) " STEP;
  # ------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    cat > webroot/lib/HelloWorld.svelte << EOF
<script lang="ts">

  let error:any = null;
  let loading:boolean = true;
  let state: Record<string, unknown> = {};

  async function fetchHelloWorld() {
    try {
      const response = await fetch('/api/helloworld');
      if (!response.ok) {
        throw new Error("Errore nel caricamento");
      }
      state = await response.json();
    } catch (err:any) {
      error = err.message;
    } finally {
      loading = false;
    }
  }

  fetchHelloWorld();

</script>

<style>
  h1 {
    font-family: 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande',
                 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
  }
</style>
  
<div>
  <h1>Hello, World!</h1>
  {#if loading}
    <p>Caricamento...</p>
  {:else if error}
    <p style="color: red;">{error}</p>
  {:else}
    {#if Object.keys(state).length === 0}
      <p style="color: red;">Error: Formato della risposta non valido</p>
    {:else}
      {#if state.err !== false}
        {#if state.log !== null}
          <p style="color: red;">Error: {state.log}</p>
        {:else}
          <p style="color: red;">Error: Il servizio ha restituito un errore</p>
        {/if}
      {:else}
        <h1>{state.result}</h1>
      {/if}
    {/if}
  {/if}
</div>
EOF
  fi
  echo "Webroot installata correttamente."
  exit 0
fi
# ==============================================================================
# NETWORK
# ==============================================================================
if [ "$option" = "network" ]; then
  if [ -z "${SERVICE_NETWORK}" ]; then
    echo "Network non specificato. Termino."
    exit 1
  fi
  if [ -n "${SERVICE_NETWORK}" ]; then
    if ! docker network ls --format '{{.Name}}' | grep -q "^${SERVICE_NETWORK}$"; then
      STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
      # ------------------------------------------------------------------------
      read -p "Creare il network ${SERVICE_NETWORK}? (y/N/s=stop) " STEP;
      # ------------------------------------------------------------------------
      case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
      if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
        docker network create "${SERVICE_NETWORK}" \
        && echo "Network ${SERVICE_NETWORK} creato."
      fi
    fi
    if ! docker network ls --format '{{.Name}}' | grep -q "^${SERVICE_NETWORK}$"; then
      echo "Network non creato. Termino."
      exit 1
    fi
  fi
  exit 0
fi
# ==============================================================================
# DATABASE SERVER
# ==============================================================================
if [ "$option" = "db-server" ]; then
  # ----------------------------------------------------------------------------
  if [ "${STEPS}" = "y" ]; then ./install.sh --network;
  else ./install.sh --network --yes; fi; if [ $? -eq 1 ]; then exit 1; fi;
  # ----------------------------------------------------------------------------
  if [ -n "${DB_CONTAINER}" ]; then
    if [ -z "$(docker ps -a -q -f name=${DB_CONTAINER})" ]; then
      if [ -n "${DB_IMAGE}" ]; then
        STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
        # ----------------------------------------------------------------------
        read -p "Installare l'immagine ${DB_IMAGE}? (y/N/s=stop) " STEP;
        # ----------------------------------------------------------------------
        case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
        if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
          docker pull $DB_IMAGE && echo "Immagine ${DB_IMAGE} installata."
        fi
      fi
      if [ "${DB_SERVER}" = "mariadb" ]; then
        if [ -n "$DB_ROOT_PASSWORD" ]; then
          STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
          # --------------------------------------------------------------------
          read -p "Avviare ${DB_CONTAINER}? (y/N/s=stop) " STEP;
          # --------------------------------------------------------------------
          case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
          if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
            docker run -d --name $DB_CONTAINER --network $SERVICE_NETWORK \
              -e MARIADB_ROOT_PASSWORD=$DB_ROOT_PASSWORD -p 3306:3306 \
              $DB_IMAGE && echo "Container ${DB_CONTAINER} installato."
          fi
        fi
        if [ -z "$(docker ps -q -f name=${DB_CONTAINER})" ]; then
          docker start $DB_CONTAINER \
          && echo "Container ${DB_CONTAINER} installato."
        fi
      fi
      if [ "${DB_SERVER}" != "mariadb" ]; then
        echo "${DB_SERVER} non supportato."
        exit 1
      fi
    else
      if [ -z "$(docker ps -q -f name=${DB_CONTAINER})" ]; then
        docker start $DB_CONTAINER \
        && echo "Container ${DB_CONTAINER} installato."
      fi
    fi
  fi
  exit 0
fi
# ==============================================================================
# DATABASE CLIENT
# ==============================================================================
if [ "$option" = "db-client" ]; then
  # ----------------------------------------------------------------------------
  # DIPENDENZA DALL'INSTALLAZIONE DEL DB SERVER DISABILITATA
  if [ "${STEPS}" = "y" ]; then ./install.sh --db-server;
  else ./install.sh --db-server --yes; fi; if [ $? -eq 1 ]; then exit 1; fi;
  # ----------------------------------------------------------------------------
  if [ -n "${DB_CONTAINER}" ]; then
    if [ -n "$(docker ps -q -f name=${DB_CONTAINER})" ]; then
      if [ "${DB_SERVER}" = "mariadb" ]; then
        if [ -n "${DB_ROOT_PASSWORD}" ]; then
          STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
          # --------------------------------------------------------------------
          read -p "Installare mysql-client? (y/N/s=stop) " STEP;
          # --------------------------------------------------------------------
          case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
          if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
            docker exec -i $DB_CONTAINER bash -c "\
              apt-get update && apt-get install -y --no-install-recommends \
              mysql-client && apt-get clean && rm -rf /var/lib/apt/lists/*" \
              && echo "mysql-client installato."
          fi
          STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
          # --------------------------------------------------------------------
          read -p "Settare i privilegi root di MariaDB? (y/N/s=stop) " STEP;
          # --------------------------------------------------------------------
          case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
          if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
            docker exec -i $DB_CONTAINER bash -c "\
              mysql -h 127.0.0.1 -uroot -p$DB_ROOT_PASSWORD -e \" \
                GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' \
                IDENTIFIED BY '$DB_ROOT_PASSWORD' WITH GRANT OPTION; \
                FLUSH PRIVILEGES;\"  2>/dev/null " \
                && echo "Privilegi root di MariaDB settati."
          fi
        else
          echo "Invalid root password"
        fi
      fi
      if [ "${DB_SERVER}" != "mariadb" ]; then
        echo "${DB_SERVER} not supported."
      fi
    fi
  fi
  exit 0
fi
# ==============================================================================
# DATABASE
# ==============================================================================
if [ "$option" = "database" ]; then
  # ----------------------------------------------------------------------------
  if [ "${STEPS}" = "y" ]; then ./install.sh --db-client;
  else ./install.sh --db-client --yes; fi; if [ $? -eq 1 ]; then exit 1; fi;
  # ----------------------------------------------------------------------------
  if [ -z "$DB_INSTALLED" ]; then
    if [ "$DB_SERVER" = "mariadb" ]; then
      if [ -n "$DB_PASSWORD" ]; then
        ROOT_PASSWORD_OPT=""
        if [ -n "$DB_ROOT_PASSWORD" ]; then
          ROOT_PASSWORD_OPT="-p${DB_ROOT_PASSWORD}"
        fi
        STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
        # ----------------------------------------------------------------------
        read -p "Creare user e database del servizio? (y/N/s=stop) " STEP;
        # ----------------------------------------------------------------------
        case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
        if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
          docker exec -i $DB_CONTAINER bash -c "\
            mysql -h 127.0.0.1 -uroot ${ROOT_PASSWORD_OPT} -e \"
            CREATE DATABASE IF NOT EXISTS $SERVICE_NAME;
            CREATE USER IF NOT EXISTS '$SERVICE_NAME'@'%' \
            IDENTIFIED BY '$DB_PASSWORD';
            GRANT ALL PRIVILEGES ON $SERVICE_NAME.* \
            TO '$SERVICE_NAME'@'%' WITH GRANT OPTION;
            FLUSH PRIVILEGES;\" && \
            echo \"User e database del servizio creati.\" && exit 0 || \
            echo \"Errori durante la creazione di user e database\" && exit 1"
          if [ $? != 0 ]; then exit 1; fi;
        fi
        if [ -n "${DB_SCHEMA}" ] && [ -f "${DB_SCHEMA}" ]; then
          STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
          # --------------------------------------------------------------------
          read -p "Creare il DB schema del servizio? (y/N/s=stop) " STEP;
          # --------------------------------------------------------------------
          case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
          if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
            cat $DB_SCHEMA | \
            docker exec -i $DB_CONTAINER mysql -h 127.0.0.1 -u$SERVICE_NAME \
            -p$DB_PASSWORD $SERVICE_NAME  2>/dev/null \
            && echo "Schema del servizio creato."
            if [ -n "${DB_DATA}" ] && [ -f "${DB_DATA}" ]; then
              STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
              # ----------------------------------------------------------------
              read -p "Inserire i dati del DB? (y/N/s=stop) " STEP;
              # ----------------------------------------------------------------
              case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
              if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
                cat $DB_DATA | \
                docker exec -i $DB_CONTAINER mysql -h 127.0.0.1 \
                -u$SERVICE_NAME -p$DB_PASSWORD $SERVICE_NAME  2>/dev/null \
                && echo "Dati del servizio inseriti."
              fi
            fi
          fi
        fi
        DB_CONN_S=""
        if [ -n "${DB_HOST}" ] && [ -n "${DB_PORT}" ] && \
          [ -n "${DB_PASSWORD}" ] && [ -n "${SERVICE_NAME}" ]; then
          STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
          # --------------------------------------------------------------------
          read -p "Settare la DB connection in .env? (y/N/s=stop) " STEP;
          # --------------------------------------------------------------------
          case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
          if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
            DB_CONN_S="host=${DB_HOST},port=${DB_PORT},"
            DB_CONN_S+="user=${SERVICE_NAME},pass=${DB_PASSWORD},"
            DB_CONN_S+="dbname=${SERVICE_NAME}"
            echo "DB_CONN_S=\"${DB_CONN_S}\"" >> .env
            echo "DB_INSTALLED=\"y\"" >> .env
            echo "Stringa di connessione al db server settata."
          fi
        fi
      fi
    fi
    if [ "${DB_SERVER}" != "mariadb" ]; then
      echo "${DB_SERVER} non supportato."
    fi
  fi
  exit 0
fi
# ==============================================================================
# RELEASE
# ==============================================================================
if [ "$option" = "release" ]; then
  # ----------------------------------------------------------------------------
  if [ "${STEPS}" = "y" ]; then ./install.sh --database;
  else ./install.sh --database; fi; if [ $? -eq 1 ]; then exit 1; fi;
  # ----------------------------------------------------------------------------
  VERS=""
  if [ -f VERSION ]; then
		VERS=$(cat VERSION)
	fi
  if [ -n "${VERS}" ]; then
    docker load -i "${SERVICE_NAME}_${VERS}.tar"
    docker run -v $(pwd)/log:/var/log -d --name $SERVICE_NAME \
    -p $SERVICE_PORT:2310 -p $SERVICE_TLS_PORT:2443 -p $SERVICE_WEB_PORT:2380 \
    -p $SERVICE_WS_PORT:2388 --network $SERVICE_NETWORK $SERVICE_NAME:$VERS
  fi
  exit 0
fi
# ==============================================================================
# INSTALL
# ==============================================================================
if [ "${STEPS}" = "y" ]; then ./install.sh --network;
else ./install.sh --network --yes; fi; if [ $? -eq 1 ]; then exit 1; fi;
# ------------------------------------------------------------------------------
if [ -z "$(docker ps -a --format '{{.Names}}' | grep "^${SERVICE_NAME}$")" ]; then
  
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  # ----------------------------------------------------------------------------
  read -p "Installare l'immagine ${SERVICE_DOCKER_IMAGE}? (y/N/s=stop) " STEP;
  # ----------------------------------------------------------------------------
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker pull $SERVICE_DOCKER_IMAGE \
    && echo "Immagine $SERVICE_DOCKER_IMAGE installata."
  fi
  # ----------------------------------------------------------------------------
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  read -p "Eseguire il run del container dev? (y/N/s=stop) " STEP;
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    LOCAL_VOLUME=$(pwd)
    if [ -n "${GITHUB_WORKSPACE}" ]; then
      LOCAL_VOLUME="${GITHUB_WORKSPACE}"
    fi
    docker run -dit --name $SERVICE_NAME --network $SERVICE_NETWORK \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$LOCAL_VOLUME:$SERVICE_WORKING_DIR" \
    -p $SERVICE_PORT:2310 -p $SERVICE_TLS_PORT:2343 -p $SERVICE_WEB_PORT:2380 \
    -p $SERVICE_WS_PORT:2388 $SERVICE_DOCKER_IMAGE \
    && echo "Run del container $SERVICE_NAME eseguito."
  fi
  # ----------------------------------------------------------------------------
else
  if [ -z "$(docker ps --format '{{.Names}}' | grep "^${SERVICE_NAME}$")" ]; then
    # --------------------------------------------------------------------------
    STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
    read -p "Eseguire lo start del container dev? (y/N/s=stop) " STEP;
    case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
    if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
      docker start $SERVICE_NAME \
      && echo "Start del container $SERVICE_NAME eseguito."
    fi
    # --------------------------------------------------------------------------
  fi
fi
# ------------------------------------------------------------------------------
STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
read -p "Installare e configurare il timezone? (y/N/s=stop) " STEP;
case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
  docker exec -i $SERVICE_NAME bash -c "\
  export DEBIAN_FRONTEND=noninteractive && \
  ln -fs /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
  echo \\\"Europe/Rome\\\" > /etc/timezone && \
  apt-get update && apt-get install -y tzdata && \
  dpkg-reconfigure -f noninteractive tzdata" \
  && echo "Timezone installato."
fi
# ------------------------------------------------------------------------------
STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
read -p "Installare le dipendenze di sviluppo? (y/N/s=stop) " STEP;
case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
  docker exec -i $SERVICE_NAME bash -c "\
  apt-get update && apt-get install -y --no-install-recommends \
  $SERVICE_DEV_DEPENDENCIES && apt-get clean && rm -rf /var/lib/apt/lists/*" \
  && echo "Dipendenze di sviluppo installate."
fi
# ------------------------------------------------------------------------------
if [ ! -d "${MONGOOSE_DIR}" ]; then
  # ----------------------------------------------------------------------------
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  read -p "Installare mongoose? (y/N/s=stop) " STEP;
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker exec -i $SERVICE_NAME bash -c "\
    cd $SERVICE_WORKING_DIR \
    && git clone ${MONGOOSE_GITHUB_REPO} ${MONGOOSE_DIR} \
    && rm -rf ${MONGOOSE_DIR}/.git" \
    && echo "Mongoose installato."
  fi
  # ----------------------------------------------------------------------------
fi
if [ ! -d "${MICROSERVICE_DIR}" ]; then
  # ----------------------------------------------------------------------------
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  read -p "Installare microservice? (y/N/s=stop) " STEP;
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker exec -i $SERVICE_NAME bash -c "\
    cd $SERVICE_WORKING_DIR \
    && git clone ${MICROSERVICE_GITHUB_REPO} ${MICROSERVICE_DIR}" \
    && echo "microservice installato."
  fi
  # ----------------------------------------------------------------------------
fi
if [ ! -d "${UNITY_DIR}" ]; then
  # ----------------------------------------------------------------------------
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  read -p "Installare unity? (y/N/s=stop) " STEP;
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker exec -i $SERVICE_NAME bash -c "\
    cd $SERVICE_WORKING_DIR \
    && git clone ${UNITY_GITHUB_REPO} ${UNITY_DIR} \
    && rm -rf ${UNITY_DIR}/.git" \
    && echo "Unity installato."
  fi
  # ----------------------------------------------------------------------------
fi

if [ ! -d "${CPPJWT_DIR}" ]; then
  # ----------------------------------------------------------------------------
  STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
  read -p "Installare cppjwt? (y/N/s=stop) " STEP;
  case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
  if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
    docker exec -i $SERVICE_NAME bash -c "\
    cd $SERVICE_WORKING_DIR \
    && git clone ${CPPJWT_GITHUB_REPO} ${CPPJWT_DIR} \
    && rm -rf ${CPPJWT_DIR}/.git \
    && cd cppjwt && mkdir -p build && cd build && cmake .. \
    && cmake --build . -j" \
    && echo "CPP-JWT installato."
  fi
  # ----------------------------------------------------------------------------
fi
# ------------------------------------------------------------------------------
STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
read -p "Create 'clear' alias? (y/N/s=stop) " STEP;
case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
  docker exec -i $SERVICE_NAME bash -c "\
  echo \"alias cls='clear'\" >> /etc/bash.bashrc && source /etc/bash.bashrc" \
  && echo "Alias del comando 'clear' creato."
fi
# ------------------------------------------------------------------------------
if [ -d ".git" ]; then
  if [ -n "$GITHUB_USER" ] && [ -n "$GITHUB_MAIL" ]; then
    # --------------------------------------------------------------------------
    STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
    read -p "Configurare git? (y/N/s=stop) " STEP;
    case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
    if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
      docker exec -i $SERVICE_NAME bash -c "\
      cd $SERVICE_WORKING_DIR \
      && git config --global --add safe.directory $SERVICE_WORKING_DIR \
      && git config user.name \"$GITHUB_USER\" \
      && git config user.email \"$GITHUB_MAIL\" \
      && git config user.name && git config user.email" \
      && echo "Git configurato."
    fi
    # --------------------------------------------------------------------------
  fi
fi
# ------------------------------------------------------------------------------
STEP="y"; if [ "${STEPS}" = "y" ]; then while true; do
read -p "Configurare locale? (y/N/s=stop) " STEP;
case "$STEP" in "" | "y" | "n" | "s") break ;; esac; done; fi;
if [ "${STEP}" = "s" ]; then exit 1; fi; if [ "${STEP}" = "y" ]; then
  docker exec -i $SERVICE_NAME bash -c "\
    if ! dpkg -l | grep -q "language-pack-en"; then \
      apt-get install -y language-pack-en; \
    fi; \
    locale-gen en_US.UTF-8; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8; \
    locale;"
fi
# ------------------------------------------------------------------------------
echo "Installazione completata."
exit 0
