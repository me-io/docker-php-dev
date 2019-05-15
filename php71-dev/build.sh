#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

REPO_NAME="meio/php-dev"
PHP_VERSION="7.1.29"
BOOT2DOCKER_ID="501"
BOOT2DOCKER_GID="20"
DEV_USER="www-data"

DOCKER_TAG=${PHP_VERSION}

if [[ ! -z "${DOCKER_PASSWORD}" && ! -z "${DOCKER_USERNAME}" ]]
then
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
fi

TAG_EXIST=`curl -s "https://hub.docker.com/v2/repositories/${REPO_NAME}/tags/${DOCKER_TAG}/" | grep '"id":'`

FORCE=$1
if [[ ! -z ${TAG_EXIST}  ]]; then
    if [[ "${FORCE}" != "f" ]]; then
        echo "${REPO_NAME}:${DOCKER_TAG} already exist"
        exit 0
    fi
fi

docker build --build-arg PHP_VERSION=${PHP_VERSION} \
             --build-arg BOOT2DOCKER_GID=${BOOT2DOCKER_GID} \
             --build-arg BOOT2DOCKER_ID=${BOOT2DOCKER_ID} \
             --build-arg DEV_USER=${DEV_USER} \
             -t ${REPO_NAME}:${PHP_VERSION} ${DIR}

if [[ $? != 0 ]]; then
    echo "${REPO_NAME}:${DOCKER_TAG} build failed"
    exit 1
fi


if [[ -z ${TAG_EXIST} -o "${FORCE}" == "f" ]]; then
    docker push ${REPO_NAME}:${PHP_VERSION}
    echo "${REPO_NAME}:${DOCKER_TAG} pushed successfully"
fi
