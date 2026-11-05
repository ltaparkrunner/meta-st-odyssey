#!/bin/bash
set -e

# Определяем абсолютный путь к папке слоя meta-st-odyssey, где лежит этот скрипт
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE}" )" && pwd )"

# Переходим на уровень выше в корень Yocto-проекта
cd "${SCRIPT_DIR}/.."
BASE_DIR=$(pwd)

echo "=== 1. Проверка и автоматическая сборка Docker-образа ==="
docker build -t crops-st:ubuntu-22.04 -f "${SCRIPT_DIR}/Dockerfile" "${SCRIPT_DIR}"

echo "=== 2. Запуск Yocto контейнера со всеми пакетами ST ==="
docker run -it --rm \
  -v "$HOME:$HOME" \
  -e USER_ID=$(id -u) \
  -e GROUP_ID=$(id -g) \
  --dns=8.8.8.8 \
  --net=host \
  --security-opt seccomp=unconfined \
  crops-st:ubuntu-22.04 \
  /bin/bash -c "cd ${BASE_DIR} && /bin/bash --login"

