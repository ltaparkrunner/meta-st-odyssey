FROM crops/poky:ubuntu-22.04

# Переключаемся на root для установки системных зависимостей STMicroelectronics
USER root

RUN apt-get update && apt-get install -y \
    bsdmainutils \
    git-lfs \
    gdisk \
    libgmp-dev \
    libmpc-dev \
    libssl-dev \
    libusb-1.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Возвращаем стандартного пользователя-инициализатора контейнеров crops
USER usersetup


