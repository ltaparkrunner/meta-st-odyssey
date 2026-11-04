#!/bin/bash
set -e

# Переходим на уровень выше, так как сборка Yocto идет в корневой папке проекта
cd ..
BASE_DIR=$(pwd)

echo "=== 1. Проверка и автоматическая сборка Docker-образа ==="
docker build -t crops-st:ubuntu-22.04 -f "${BASE_DIR}/meta-st-odyssey/Dockerfile" "${BASE_DIR}/meta-st-odyssey"

echo "=== 2. Запуск Yocto контейнера со всеми пакетами ST ==="
docker run -it --rm \
  -v "$HOME:$HOME" \
  -w "${BASE_DIR}" \
  -e USER_ID=$(id -u) \
  -e GROUP_ID=$(id -g) \
  --dns=8.8.8.8 \
  --net=host \
  --security-opt seccomp=unconfined \
  crops-st:ubuntu-22.04

