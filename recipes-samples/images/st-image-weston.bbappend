# Добавляем модули Qt6 и QML в образ Weston автоматически при сборке
IMAGE_INSTALL:append = " \
    qtbase \
    qtbase-plugins \
    qtdeclarative \
    qtdeclarative-qmlplugins \
    qtdeclarative-tools \
    qtquick3d \
    qtwayland \
    ttf-dejavu-sans \
"

