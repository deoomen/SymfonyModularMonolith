#!/usr/bin/env bash
set -e -u
source $DOCKERUTIL_PATH
set -a
source ./bin/test/.env
set +a

docker service create \
  --name ${MYSQL_SERVICE} \
  ${COMMON_SERVICE_CREATE_OPTIONS[@]} \
  --publish "${MYSQL_SERVICE_PUBLISH_PORT}:${MYSQL_SERVICE_PORT}" \
  --secret ${MYSQL_PASSWORD_SECRET} \
  --env "MYSQL_ROOT_PASSWORD_FILE=/run/secrets/${MYSQL_PASSWORD_SECRET}" \
  ${MYSQL_SERVICE_IMAGE}

dockerutil::print_success "created service: $MYSQL_SERVICE"

docker service create \
  --name "${MYSQL_ADMIN_SERVICE}" \
  ${COMMON_SERVICE_CREATE_OPTIONS[@]} \
  --publish "${MYSQL_ADMIN_PUBLISH_PORT}:${MYSQL_ADMIN_PORT}" \
  --env PMA_HOST=$MYSQL_SERVICE \
  ${MYSQL_ADMIN_SERVICE_IMAGE} >/dev/null

dockerutil::print_success "created service: ${MYSQL_ADMIN_SERVICE}"